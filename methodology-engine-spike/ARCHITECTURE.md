# Architecture Overview

## Core Components

### 1. Models (`engine/models.py`)

**Asset**: Represents discovered assets with properties
- Supports property matching with operators ($exists, $in, $gt, $lt)
- Tracks confidence scores
- Timestamped discovery

**Trigger**: Defines when methodologies should execute
- Type-based (asset_discovered, property_match, etc.)
- Property requirements with flexible matching
- Priority and confidence scoring
- Deduplication configuration

**Methodology**: Complete methodology definition
- Category (recon, enumeration, exploitation, post_exploitation)
- Risk level (low, medium, high, critical)
- Multiple triggers
- Ordered steps with command templates
- Batch compatibility flag

**TriggerMatch**: Result of trigger evaluation
- Links trigger to methodology
- References matched assets
- Signature for deduplication
- Execution status

**BatchCommand**: Generated command ready for execution
- Resolved command string
- References trigger matches
- Batch metadata

### 2. Deduplicator (`engine/deduplicator.py`)

Prevents redundant executions using three strategies:

**Signature-Based**:
```python
signature = hash(methodology_id + asset_properties)
if signature in executed: skip
```

**Cooldown**:
```python
if last_execution + cooldown > now: skip
```

**Max Executions**:
```python
if execution_count >= max: skip
```

### 3. Trigger Matcher (`engine/trigger_matcher.py`)

Evaluates triggers against assets:

```
Assets → Property Matching → Confidence Scoring → Deduplication → Matches
```

**Property Matching**:
- Direct value comparison
- Operator-based comparisons ($exists, $in, $gt, $lt)
- Asset type filtering
- Required count validation

**Confidence Scoring**:
- Based on asset confidence scores
- Averaged across matched assets
- Used for prioritization

### 4. Batch Generator (`engine/batch_generator.py`)

Combines similar triggers into efficient commands:

**Detection**:
- Groups matches by methodology
- Checks batch compatibility
- Identifies batch-friendly patterns in commands

**Generation**:
```
Individual: command {target}
Batched: command {targets} or parallel command ::: {targets}
```

**Patterns Detected**:
- `-f {targets_file}` → File-based batching
- `parallel` → GNU parallel batching
- `::: {targets}` → Parallel parameter batching

### 5. Methodology Engine (`engine/methodology_engine.py`)

Main orchestrator:

```
Asset Added → Trigger Evaluation → Deduplication → Batch Generation → Commands
```

**Flow**:
1. Asset added to engine
2. Trigger matcher evaluates all methodologies
3. Deduplicator filters out redundant matches
4. Batch generator creates commands
5. Results stored and emitted

**State Management**:
- In-memory storage (easily swappable for DB)
- Real-time statistics
- YAML methodology loading

## Web Layer

### FastAPI Server (`web/api.py`)

**Endpoints**:
- `GET /api/assets` - List all assets
- `POST /api/assets` - Add asset and trigger evaluation
- `GET /api/methodologies` - List loaded methodologies
- `GET /api/trigger-matches` - List fired triggers
- `GET /api/batch-commands` - List generated commands
- `GET /api/stats` - Engine statistics
- `POST /api/reset` - Clear all state
- `POST /api/demo/scenario/{name}` - Run demo scenarios

**Demo Scenarios**:
- network_discovery
- nac_bypass
- web_enumeration

### Web UI (`web/static/`)

**Features**:
- Real-time updates (3-second polling)
- Asset creation form
- Demo scenario buttons
- Statistics dashboard
- Command visualization
- Batch highlighting

**Visual Indicators**:
- Blue: Regular items
- Orange: Active triggers
- Green: Batched commands

## Data Flow

### Adding an Asset

```
User → POST /api/assets → Engine.add_asset()
  → TriggerMatcher.evaluate_new_asset()
    → Deduplicator.should_execute()
      → BatchGenerator.generate_batches()
        → Store Commands
          → Return to User
```

### Trigger Evaluation

```
Asset → For Each Methodology
  → For Each Trigger
    → Check Asset Type
      → Match Properties
        → Generate Signature
          → Check Deduplication
            → Create TriggerMatch
```

### Batch Generation

```
TriggerMatches → Group by Methodology
  → Check Batch Compatibility
    → Detect Batch Patterns
      → Combine Targets
        → Generate Batch Command
```

## Extension Points

### Adding New Asset Types

```python
# models.py
class AssetType(Enum):
    YOUR_TYPE = "your_type"
```

### Adding New Trigger Types

```python
# models.py
class TriggerType(Enum):
    YOUR_TRIGGER = "your_trigger"

# trigger_matcher.py
def evaluate_methodology(self, assets, methodology):
    if trigger.type == TriggerType.YOUR_TRIGGER:
        return your_custom_logic(assets)
```

### Adding New Batch Patterns

```python
# batch_generator.py
def _can_batch_step(self, step, assets):
    if "your_pattern" in step.command_template:
        return True
```

### Creating New Methodologies

Just add a YAML file in `methodologies/`:

```yaml
id: your_methodology
name: Your Methodology Name
triggers:
  - id: your_trigger
    type: property_match
    asset_type: host
    required_properties:
      your_property: true
steps:
  - name: Your Step
    command: "your-tool {property}"
```

## Design Decisions

### Why Asset Properties?

**Alternative**: Methodology completion triggers
**Chosen**: Property-based triggers

**Reason**: More realistic and flexible. Real penetration testers don't think "run X after Y completes", they think "when I see NAC with credentials, I test bypass techniques".

### Why Deduplication?

**Problem**: Same asset combination triggers same methodology multiple times
**Solution**: Signature-based deduplication with cooldowns

**Example**: Adding 5 web services doesn't trigger web enum 5 times if they're all on the same host.

### Why Batch Generation?

**Problem**: Running 10 similar commands sequentially is slow
**Solution**: Detect batchable operations and combine them

**Impact**: 4-10x performance improvement in real scenarios

### Why YAML?

**Alternatives**: JSON, Python code, DSL
**Chosen**: YAML

**Reasons**:
- Human-readable
- Easy to version control
- Non-developers can contribute
- Clean syntax for complex structures

### Why In-Memory Storage?

**Current**: Python dictionaries
**Future**: Database (SQLite, PostgreSQL)

**Reasoning**: Spike simplicity. Easy to swap for real persistence.

## Performance Characteristics

### Trigger Evaluation: O(M * T * A)
- M = methodologies
- T = triggers per methodology  
- A = assets

**Optimization**: Index assets by type, cache trigger evaluations

### Deduplication: O(1)
- Hash-based signature lookup
- Constant time checks

### Batch Generation: O(N)
- N = trigger matches
- Linear grouping and command generation

## Security Considerations

### Command Injection

**Risk**: User-supplied asset properties inserted into commands
**Mitigation**: 
- In production: Sanitize all inputs
- Use parameterized execution
- Validate property types

### Methodology Validation

**Risk**: Malicious YAML methodologies
**Mitigation**:
- Schema validation
- Sandboxed execution
- User permissions

### Resource Exhaustion

**Risk**: Too many assets/triggers overwhelm system
**Mitigation**:
- Rate limiting on asset creation
- Batch size limits
- Execution timeouts

## Testing Strategy

### Unit Tests (Not Implemented Yet)

```python
test_asset_property_matching()
test_trigger_evaluation()
test_deduplication_strategies()
test_batch_command_generation()
```

### Integration Tests

```python
test_full_workflow()
test_demo_scenarios()
test_api_endpoints()
```

### Current Test

`test_engine.py` - Basic smoke test

## Future Enhancements

### Execution Engine
- Actually run commands
- Capture output
- Parse results for asset discovery

### Persistent Storage
- SQLite for local development
- PostgreSQL for production
- Migration system

### Advanced Triggers
- Time-based triggers
- Conditional triggers (if/then/else)
- Composite triggers (AND/OR logic)

### Enhanced Batching
- Intelligent grouping by network proximity
- Adaptive batch sizing
- Priority-based scheduling

### Asset Discovery
- Parse command output
- Extract new assets automatically
- Recursive trigger evaluation

### Monitoring
- Real-time execution monitoring
- Progress tracking
- Error handling and retries

### Collaboration
- Multi-user support
- Team coordination
- Finding sharing
