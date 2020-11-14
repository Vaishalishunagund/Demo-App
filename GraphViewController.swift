//
//  GraphViewController.swift
//  Demo-App
//
//  Created by Apple on 12/11/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import UIKit
import Charts
import FSPagerView

class GraphViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var graphView: FSPagerView!
    {
        didSet {
            self.graphView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theAppModel.sharedInstance.fetchRecord()
            
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GraphViewController : FSPagerViewDataSource, FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return theAppModel.sharedInstance.months.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let chartView = BarChartView()
        chartView.frame = cell.contentView.bounds
        chartView.delegate = self
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        chartView.legend.setCustom(entries: [])
        var entries = [BarChartDataEntry]()
        
        let i : Int = 0
        
        for i in 0..<theAppModel.sharedInstance.stats.count
        {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(theAppModel.sharedInstance.stats[i])))
        }
        
        theAppModel.sharedInstance.setXAxisDataSet(dataSet: theAppModel.sharedInstance.months)

       let barChartDataSet = BarChartDataSet(entries: entries, label: "")
        barChartDataSet.colors = [UIColor.systemIndigo]
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = StringValueFormatterForGraphData(chart: chartView)
        
        chartView.data = barChartData
        chartView.backgroundColor = .white
        chartView.drawBarShadowEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelCount = 5
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        cell.contentView.addSubview(chartView)
        chartView.fitScreen()
        cell.contentView.addSubview(chartView)
        return cell
    }
    
    
}
