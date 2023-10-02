import 'package:flutter/material.dart';
import 'package:yaquby/models/rep_sales_target_response_model.dart';

class TargetProgressCustomWidget extends StatelessWidget {
  final List<RepSalesTargetData> targetData;

  const TargetProgressCustomWidget({
    Key? key,
    required this.targetData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: targetData.map((target) {
        final fromDate = DateTime.parse(target.fromDate);
        final toDate = DateTime.parse(target.toDate);
        final targetAmount = target.targetAmount;
        final achievedAmount = target.achievedAmount;

        // Calculate the progress percentage
        final progress = (achievedAmount / targetAmount).clamp(0.0, 1.0);

        return Card(
          margin: const EdgeInsets.fromLTRB(20,10,20,0),
          elevation: 3, // Add a slight shadow to the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Add rounded corners
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              'Target Period : ${fromDate.day}-${fromDate.month}-${fromDate.year} to ${toDate.day}-${toDate.month}-${toDate.year} ',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      'Target Amount:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'BHD $targetAmount',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Achieved Amount:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'BHD $achievedAmount',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress, // Set the progress value
                  color: Colors.blue, // Customize the progress bar color
                  backgroundColor: Colors.grey.withOpacity(0.5), // Customize the background color
                ),
                const SizedBox(height: 10),
                Text(
                  'Progress: ${(progress * 100).toStringAsFixed(2)}%', // Display progress percentage
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              // Add interactivity, e.g., navigate to a detailed view
              // when the card is tapped.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    // You can create a detailed view here.
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('Target Details'),
                      ),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('From: ${fromDate.year}-${fromDate.month}'),
                            Text('To: ${toDate.year}-${toDate.month}'),
                            Text('Target Amount: $targetAmount'),
                            Text('Achieved Amount: $achievedAmount'),
                            // Add more details here as needed.
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
