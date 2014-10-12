require 'net/http'
require 'json'

class MainController < ApplicationController
      #define a search method which visits odata.org and fetch data
	def search
		#define three variable
		product_name = ""
		supplier_name = ""
		product_id = params[:product_id]
		# Set up the URL
            url = "http://services.odata.org/Northwind/Northwind.svc/Products(#{product_id})?$format=json"
            # Make an HTTP request and place the result in jsonStr
            jsonStr = Net::HTTP.get_response(URI.parse(url))
            data = jsonStr.body
            jsonHash = JSON.parse(data)
       
            if (jsonHash["Discontinued"]) 
    
                  @product_name = "is a discontinued product"
                  @supplier_name = "n/a"

            else 


                  #@product_name = jsonHash["ProductName"].to_s #prints the product name
                  supplier_id = jsonHash["SupplierID"].to_s#get the SupplierID from Products url
                  #construct a url for retrieving supplier
                  urlSupplier = "http://services.odata.org/Northwind/Northwind.svc/Suppliers(#{supplier_id})?$format=json"
                  # Make an HTTP request and place the result in jsonStrSupplier
                  jsonStrSupplier = Net::HTTP.get_response(URI.parse(urlSupplier))
                  dataSupplier = jsonStrSupplier.body
                  jsonSupplierHash = JSON.parse(dataSupplier)#parse the json data from the text
                  # print the SupplierName, note that the actual supplier name is labeled as "Company Name"
                  #@supplier_name = jsonSupplierHash["CompanyName"].to_s

                  if jsonHash["ProductName"]#if ProductName exists, then assign the value to the variable
                        @product_name = jsonHash["ProductName"].to_s
                  else
                        @product_name = "n/a"#if not, assign n/a
                  end

                  if jsonSupplierHash["CompanyName"]#if CompanyName exists, then assign the value to the variable
                        @supplier_name = jsonSupplierHash["CompanyName"].to_s
                  else
                        @supplier_name = "n/a"#if not, assign n/a
                  end
            end


	end
end
