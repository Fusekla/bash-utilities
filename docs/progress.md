### 2025-08-23
- Ran `shellcheck` on `pods-by-ns.sh` and `extract-images.sh`
  - Fixed `SC2128 (warning): Expanding an array without an index only gives the first element.`
  - Fixed `SC2155 (warning): Declare and assign separately to avoid masking return values.`

### 2025-08-19
- Added `extract-images.sh` script to extract images used in all deployments across cluster
  - Learned about `shellcheck` utility and some `jq` functionality

### 2025-08-18
- Added `topN.sh` script to print most common words in provided file
  - Learned about new flags in `uniq` and `sort`

### 2025-08-12
- Refactored repository to scalable structure from previously used date based folder maze