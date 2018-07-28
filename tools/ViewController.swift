/*********************************************************************/
//  ViewController.swift
//  NumerisRomanis
//
//  Copyright © 2018 Wylder Media Group, LLC. All rights reserved.
//  Please refer to the license in the Docs Directory for more info
//
/*********************************************************************/

import Cocoa
import WebKit


class ViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadHTMLFile("README", "html")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }

    func loadHTMLFile(_ fileName: String, _ ext: String ) {
        
        do {
            guard let filePath = Bundle.main.path(forResource: fileName, ofType: ext)
                else {
                    // File Error
                    dialogBox(title: "Error getting file:", text: "File not found.")
                    return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            dialogBox(title: "Error reading file:", text: "couldn't proccess the file.")
        }
    }

    
    @IBAction func licenseButtonPressed(_ sender: NSButton) {
        loadHTMLFile("LICENSE", "html")
    }
    
   
    @IBAction func readmeButtonPressed(_ sender: NSButton) {
        loadHTMLFile("README", "html")
        
    }
    
    func dialogBox(title: String, text: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        let _ = alert.runModal() == .alertFirstButtonReturn
    }
    
    
}

