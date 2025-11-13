"""Asset relationship management and graph queries."""
from typing import List, Dict, Optional, Set
from .models import Asset, AssetRelationship, RelationshipType, AssetType


class RelationshipManager:
    """Manages relationships between assets and provides graph traversal capabilities."""

    def __init__(self):
        self.relationships: Dict[str, AssetRelationship] = {}
        self.assets_by_id: Dict[str, Asset] = {}

        # Index relationships for fast queries
        self._outgoing: Dict[str, List[AssetRelationship]] = {}  # source_id -> relationships
        self._incoming: Dict[str, List[AssetRelationship]] = {}  # target_id -> relationships

    def add_asset(self, asset: Asset):
        """Register an asset with the relationship manager."""
        self.assets_by_id[asset.id] = asset
        if asset.id not in self._outgoing:
            self._outgoing[asset.id] = []
        if asset.id not in self._incoming:
            self._incoming[asset.id] = []

    def add_relationship(self, relationship: AssetRelationship):
        """Add a relationship between two assets."""
        self.relationships[relationship.id] = relationship

        # Update indices
        if relationship.source_asset_id not in self._outgoing:
            self._outgoing[relationship.source_asset_id] = []
        self._outgoing[relationship.source_asset_id].append(relationship)

        if relationship.target_asset_id not in self._incoming:
            self._incoming[relationship.target_asset_id] = []
        self._incoming[relationship.target_asset_id].append(relationship)

    def get_relationships(
        self,
        asset_id: Optional[str] = None,
        relationship_type: Optional[RelationshipType] = None,
        direction: str = "both"  # "outgoing", "incoming", "both"
    ) -> List[AssetRelationship]:
        """Get relationships for an asset, optionally filtered by type and direction."""
        if asset_id is None:
            # Return all relationships
            results = list(self.relationships.values())
        else:
            results = []
            if direction in ["outgoing", "both"]:
                results.extend(self._outgoing.get(asset_id, []))
            if direction in ["incoming", "both"]:
                results.extend(self._incoming.get(asset_id, []))

        # Filter by relationship type if specified
        if relationship_type:
            results = [r for r in results if r.relationship_type == relationship_type]

        return results

    def get_related_assets(
        self,
        asset_id: str,
        relationship_type: Optional[RelationshipType] = None,
        direction: str = "outgoing"
    ) -> List[Asset]:
        """Get assets related to the given asset."""
        relationships = self.get_relationships(asset_id, relationship_type, direction)

        related_asset_ids = set()
        for rel in relationships:
            if direction == "outgoing" or (direction == "both" and rel.source_asset_id == asset_id):
                related_asset_ids.add(rel.target_asset_id)
            if direction == "incoming" or (direction == "both" and rel.target_asset_id == asset_id):
                related_asset_ids.add(rel.source_asset_id)

        return [self.assets_by_id[aid] for aid in related_asset_ids if aid in self.assets_by_id]

    def find_pivot_paths(self, from_asset_id: str, to_network_cidr: str) -> List[List[Asset]]:
        """Find all pivot paths from a compromised host to a target network.

        This is CRITICAL for real pentesting - finding multi-hop paths through dual-homed hosts.
        """
        paths = []
        visited = set()

        def dfs(current_id: str, target_cidr: str, path: List[Asset]):
            if current_id in visited:
                return

            visited.add(current_id)
            current_asset = self.assets_by_id.get(current_id)
            if not current_asset:
                return

            path.append(current_asset)

            # Check if current asset can reach target network
            if current_asset.type == AssetType.HOST:
                # Check network interfaces for connectivity
                interfaces = current_asset.properties.get("network_interfaces", [])
                for iface in interfaces:
                    if iface.get("network") == target_cidr:
                        paths.append(list(path))
                        path.pop()
                        visited.remove(current_id)
                        return

            # Continue searching through CAN_PIVOT_TO relationships
            pivot_rels = self.get_relationships(
                current_id,
                RelationshipType.CAN_PIVOT_TO,
                direction="outgoing"
            )

            for rel in pivot_rels:
                dfs(rel.target_asset_id, target_cidr, path)

            path.pop()
            visited.remove(current_id)

        dfs(from_asset_id, to_network_cidr, [])
        return paths

    def find_attack_paths(
        self,
        from_asset_id: str,
        to_asset_id: str,
        max_depth: int = 5
    ) -> List[List[AssetRelationship]]:
        """Find attack paths from one asset to another.

        Returns list of relationship chains that could be exploited.
        """
        paths = []

        def bfs():
            queue = [([from_asset_id], [])]  # (asset_path, relationship_path)
            visited = {from_asset_id}

            while queue:
                asset_path, rel_path = queue.pop(0)
                current = asset_path[-1]

                if len(asset_path) > max_depth:
                    continue

                if current == to_asset_id:
                    paths.append(rel_path)
                    continue

                # Explore relationships that could lead to compromise
                attack_rels = self.get_relationships(current, direction="outgoing")
                for rel in attack_rels:
                    target_id = rel.target_asset_id
                    if target_id not in visited:
                        visited.add(target_id)
                        queue.append(
                            (asset_path + [target_id], rel_path + [rel])
                        )

        bfs()
        return paths

    def get_assets_with_property(
        self,
        property_name: str,
        property_value: Optional[any] = None,
        asset_type: Optional[AssetType] = None
    ) -> List[Asset]:
        """Find all assets with a specific property."""
        results = []

        for asset in self.assets_by_id.values():
            # Filter by asset type if specified
            if asset_type and asset.type != asset_type:
                continue

            # Check if property exists
            if property_name not in asset.properties:
                continue

            # Check value if specified
            if property_value is not None:
                if asset.properties[property_name] != property_value:
                    continue

            results.append(asset)

        return results

    def get_compromise_candidates(self) -> List[Dict]:
        """Identify high-value compromise candidates based on relationships.

        Returns assets that would enable significant lateral movement or privilege escalation.
        """
        candidates = []

        for asset_id, asset in self.assets_by_id.items():
            score = 0
            reasons = []

            # Multi-homed hosts (pivoting opportunities)
            if asset.type == AssetType.HOST:
                interfaces = asset.properties.get("network_interfaces", [])
                if len(interfaces) > 1:
                    score += 50
                    reasons.append(f"Dual-homed: Can pivot to {len(interfaces)} networks")

            # Firewall-allowlisted hosts
            if asset.type == AssetType.HOST:
                allowlist = asset.properties.get("firewall_allowlisted_for", [])
                if allowlist:
                    score += 40
                    reasons.append(f"Firewall allowlisted for {len(allowlist)} networks")

            # Hosts with high-privilege accounts
            admin_users = asset.properties.get("admin_users", [])
            if admin_users:
                score += 30
                reasons.append(f"Has {len(admin_users)} admin accounts")

            # Applications with privesc potential
            apps = asset.properties.get("installed_applications", [])
            for app in apps:
                if app.get("privesc_potential") in ["high", "critical"]:
                    score += 25
                    reasons.append(f"{app['name']}: High privesc potential")

            # Count of outgoing attack relationships
            attack_relationships = len(self.get_relationships(asset_id, direction="outgoing"))
            score += attack_relationships * 2
            if attack_relationships > 5:
                reasons.append(f"Connected to {attack_relationships} other assets")

            if score > 0:
                candidates.append({
                    "asset": asset,
                    "score": score,
                    "reasons": reasons
                })

        # Sort by score descending
        candidates.sort(key=lambda x: x["score"], reverse=True)
        return candidates

    def get_stats(self) -> Dict:
        """Get relationship statistics."""
        rel_type_counts = {}
        for rel in self.relationships.values():
            rel_type = rel.relationship_type.value
            rel_type_counts[rel_type] = rel_type_counts.get(rel_type, 0) + 1

        return {
            "total_assets": len(self.assets_by_id),
            "total_relationships": len(self.relationships),
            "relationships_by_type": rel_type_counts,
            "avg_relationships_per_asset": len(self.relationships) / max(len(self.assets_by_id), 1)
        }

    def clear(self):
        """Clear all relationships and assets."""
        self.relationships.clear()
        self.assets_by_id.clear()
        self._outgoing.clear()
        self._incoming.clear()
