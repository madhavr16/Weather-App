import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon1;
  final String value1;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon1,
    required this.value1,
    }
    );

  @override
  Widget build(BuildContext context) {
    return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 90,
                                child: Column(
                                  children: [
                                    Text(time,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Icon(
                                    icon1,
                                    size: 32,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(value1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
  }
}