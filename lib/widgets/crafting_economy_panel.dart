import 'package:flutter/material.dart';
import 'package:eden_preprocessor_demo/models/crafting_economy.dart';

/// Widget for managing crafting projects, merchant inventories, and dynamic economy
class CraftingEconomyPanel extends StatefulWidget {
  final List<CraftingProject> activeCraftingProjects;
  final List<CraftingRecipe> availableRecipes;
  final List<MerchantInventory> merchantInventories;
  final Map<String, DynamicPrice> itemPrices;
  final Function(String recipeId) onStartCraftingProject;
  final Function(String projectId) onWorkOnProject;
  final Function(String merchantId, String itemId, int quantity) onPurchaseItem;
  final String characterId;

  const CraftingEconomyPanel({
    Key? key,
    required this.activeCraftingProjects,
    required this.availableRecipes,
    required this.merchantInventories,
    required this.itemPrices,
    required this.onStartCraftingProject,
    required this.onWorkOnProject,
    required this.onPurchaseItem,
    required this.characterId,
  }) : super(key: key);

  @override
  State<CraftingEconomyPanel> createState() => _CraftingEconomyPanelState();
}

class _CraftingEconomyPanelState extends State<CraftingEconomyPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedMerchantId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.merchantInventories.isNotEmpty) {
      _selectedMerchantId = widget.merchantInventories.first.merchantId;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var characterProjects = widget.activeCraftingProjects
        .where((p) => p.characterId == widget.characterId)
        .toList();

    return Card(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.construction, size: 24),
                SizedBox(width: 8),
                Text(
                  'Crafting & Economy',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.build),
                text: 'Crafting (${characterProjects.length})',
              ),
              Tab(
                icon: Icon(Icons.store),
                text: 'Merchants (${widget.merchantInventories.length})',
              ),
              Tab(
                icon: Icon(Icons.trending_up),
                text: 'Market',
              ),
            ],
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCraftingTab(characterProjects),
                _buildMerchantsTab(),
                _buildMarketTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCraftingTab(List<CraftingProject> characterProjects) {
    return Column(
      children: [
        // Active projects
        Expanded(
          child: characterProjects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No active crafting projects', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Start Crafting'),
                        onPressed: () => _showRecipeSelectorDialog(context),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: characterProjects.length,
                  itemBuilder: (context, index) {
                    var craftingProject = characterProjects[index];
                    return _buildCraftingProjectCard(craftingProject);
                  },
                ),
        ),

        // Start new project button
        if (characterProjects.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Start New Project'),
              onPressed: () => _showRecipeSelectorDialog(context),
            ),
          ),
      ],
    );
  }

  Widget _buildCraftingProjectCard(CraftingProject craftingProject) {
    var craftingRecipe = widget.availableRecipes.firstWhere(
      (r) => r.recipeId == craftingProject.recipeId,
      orElse: () => widget.availableRecipes.first,
    );

    Color statusColor = _getProjectStatusColor(craftingProject.projectStatus);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.build_circle, color: statusColor),
        ),
        title: Text(
          craftingRecipe.resultingItemName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    craftingProject.projectStatus.name.toUpperCase(),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: craftingProject.progressPercentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
                SizedBox(width: 8),
                Text('${craftingProject.progressPercentage}%'),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Days Worked', style: TextStyle(fontSize: 12)),
                        Text(
                          '${craftingProject.daysWorked}/${craftingProject.totalDaysRequired}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Quality Score', style: TextStyle(fontSize: 12)),
                        Text(
                          '${craftingProject.qualityScore}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getQualityColor(craftingProject.qualityScore),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Cost', style: TextStyle(fontSize: 12)),
                        Text(
                          '${craftingProject.totalCostGold} gp',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Materials status
                Row(
                  children: [
                    Icon(
                      craftingProject.materialsAcquired ? Icons.check_circle : Icons.cancel,
                      color: craftingProject.materialsAcquired ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text('Materials', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 16),
                    Icon(
                      craftingProject.workshopSecured ? Icons.check_circle : Icons.cancel,
                      color: craftingProject.workshopSecured ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text('Workshop', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 12),

                // Recent checks
                if (craftingProject.craftingChecks.isNotEmpty) ...[
                  Text(
                    'Recent Checks:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  ...craftingProject.craftingChecks.reversed.take(3).map((craftingCheck) {
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        craftingCheck.checkSuccess ? Icons.check : Icons.close,
                        color: craftingCheck.checkSuccess ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      title: Text(
                        'Roll: ${craftingCheck.checkRoll} vs DC ${craftingCheck.checkDC}',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        '${craftingCheck.qualityContribution > 0 ? '+' : ''}${craftingCheck.qualityContribution}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: craftingCheck.qualityContribution > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 12),
                ],

                // Action button
                if (craftingProject.projectStatus == CraftingStatus.inProgress)
                  ElevatedButton.icon(
                    icon: Icon(Icons.work, size: 16),
                    label: Text('Work Today'),
                    onPressed: () => widget.onWorkOnProject(craftingProject.projectId),
                  )
                else if (craftingProject.projectStatus == CraftingStatus.readyToFinish)
                  ElevatedButton.icon(
                    icon: Icon(Icons.check, size: 16),
                    label: Text('Complete Project'),
                    onPressed: () => _showCompleteProjectDialog(context, craftingProject),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantsTab() {
    if (widget.merchantInventories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No merchants available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    var selectedMerchant = widget.merchantInventories.firstWhere(
      (m) => m.merchantId == _selectedMerchantId,
      orElse: () => widget.merchantInventories.first,
    );

    return Column(
      children: [
        // Merchant selector
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            value: _selectedMerchantId,
            decoration: InputDecoration(
              labelText: 'Select Merchant',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.store),
            ),
            items: widget.merchantInventories.map((merchantInventory) {
              return DropdownMenuItem(
                value: merchantInventory.merchantId,
                child: Text(merchantInventory.merchantName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMerchantId = value;
                });
              }
            },
          ),
        ),

        // Merchant info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Price Modifier', style: TextStyle(fontSize: 12)),
                  Text(
                    '${(selectedMerchant.basePriceModifier * 100).round()}%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Location', style: TextStyle(fontSize: 12)),
                  Text(
                    selectedMerchant.locationId,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Items', style: TextStyle(fontSize: 12)),
                  Text(
                    '${selectedMerchant.merchantItems.length}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Inventory
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: selectedMerchant.merchantItems.length,
            itemBuilder: (context, index) {
              var entry = selectedMerchant.merchantItems.entries.elementAt(index);
              var merchantItem = entry.value;
              var dynamicPrice = widget.itemPrices[merchantItem.itemId];

              return _buildMerchantItemCard(selectedMerchant, merchantItem, dynamicPrice);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMerchantItemCard(
    MerchantInventory merchantInventory,
    MerchantItem merchantItem,
    DynamicPrice? dynamicPrice,
  ) {
    int basePrice = dynamicPrice?.basePrice ?? 100;
    int currentPrice = dynamicPrice?.getCurrentPrice(locationId: merchantInventory.locationId) ?? basePrice;
    int finalPrice = merchantInventory.getPriceForCharacter(merchantItem.itemId, widget.characterId, currentPrice);

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.inventory_2),
        title: Text(merchantItem.itemName),
        subtitle: Row(
          children: [
            Text('Stock: ${merchantItem.stockQuantity}'),
            SizedBox(width: 16),
            if (dynamicPrice != null && dynamicPrice.currentPriceModifier != 1.0)
              Icon(
                dynamicPrice.priceTrend == TrendDirection.rising ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: dynamicPrice.priceTrend == TrendDirection.rising ? Colors.red : Colors.green,
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$finalPrice gp',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (finalPrice != basePrice)
              Text(
                '$basePrice gp',
                style: TextStyle(
                  fontSize: 10,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        onTap: merchantItem.stockQuantity > 0
            ? () => _showPurchaseDialog(context, merchantInventory, merchantItem, finalPrice)
            : null,
      ),
    );
  }

  Widget _buildMarketTab() {
    var risingPrices = widget.itemPrices.values
        .where((p) => p.priceTrend == TrendDirection.rising)
        .toList()
      ..sort((a, b) => b.currentPriceModifier.compareTo(a.currentPriceModifier));

    var fallingPrices = widget.itemPrices.values
        .where((p) => p.priceTrend == TrendDirection.falling)
        .toList()
      ..sort((a, b) => a.currentPriceModifier.compareTo(b.currentPriceModifier));

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Rising prices
        Text(
          'Rising Prices',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ...risingPrices.take(5).map((dynamicPrice) {
          return _buildMarketItemCard(dynamicPrice, true);
        }).toList(),
        SizedBox(height: 16),

        // Falling prices
        Text(
          'Falling Prices',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ...fallingPrices.take(5).map((dynamicPrice) {
          return _buildMarketItemCard(dynamicPrice, false);
        }).toList(),
      ],
    );
  }

  Widget _buildMarketItemCard(DynamicPrice dynamicPrice, bool isRising) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isRising ? Icons.trending_up : Icons.trending_down,
          color: isRising ? Colors.red : Colors.green,
        ),
        title: Text(dynamicPrice.itemName),
        subtitle: Row(
          children: [
            Text('Supply: ${dynamicPrice.supplyLevel}'),
            SizedBox(width: 16),
            Text('Demand: ${dynamicPrice.demandLevel}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(dynamicPrice.currentPriceModifier * 100).round()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isRising ? Colors.red : Colors.green,
              ),
            ),
            Text(
              '${dynamicPrice.basePrice} gp base',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProjectStatusColor(CraftingStatus projectStatus) {
    switch (projectStatus) {
      case CraftingStatus.planning:
        return Colors.grey;
      case CraftingStatus.inProgress:
        return Colors.blue;
      case CraftingStatus.readyToFinish:
        return Colors.green;
      case CraftingStatus.completed:
        return Colors.purple;
      case CraftingStatus.failed:
        return Colors.red;
      case CraftingStatus.abandoned:
        return Colors.brown;
    }
  }

  Color _getQualityColor(int qualityScore) {
    if (qualityScore >= 40) return Colors.purple;
    if (qualityScore >= 20) return Colors.green;
    if (qualityScore >= 0) return Colors.orange;
    return Colors.red;
  }

  void _showRecipeSelectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Recipe'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.availableRecipes.length,
            itemBuilder: (context, index) {
              var craftingRecipe = widget.availableRecipes[index];
              return ListTile(
                title: Text(craftingRecipe.resultingItemName),
                subtitle: Text('${craftingRecipe.craftingTimeDays} days • ${craftingRecipe.baseCostGold} gp'),
                trailing: Chip(
                  label: Text(craftingRecipe.itemRarity.name),
                ),
                onTap: () {
                  widget.onStartCraftingProject(craftingRecipe.recipeId);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCompleteProjectDialog(BuildContext context, CraftingProject craftingProject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Complete Project'),
        content: Text('Ready to finalize your crafting project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Complete project logic
              Navigator.pop(context);
            },
            child: Text('Complete'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(
    BuildContext context,
    MerchantInventory merchantInventory,
    MerchantItem merchantItem,
    int finalPrice,
  ) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Purchase ${merchantItem.itemName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Price: $finalPrice gp each'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: quantity > 1
                        ? () {
                            setDialogState(() {
                              quantity--;
                            });
                          }
                        : null,
                  ),
                  Text(
                    '$quantity',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: quantity < merchantItem.stockQuantity
                        ? () {
                            setDialogState(() {
                              quantity++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Total: ${finalPrice * quantity} gp',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onPurchaseItem(merchantInventory.merchantId, merchantItem.itemId, quantity);
                Navigator.pop(context);
              },
              child: Text('Purchase'),
            ),
          ],
        ),
      ),
    );
  }
}
