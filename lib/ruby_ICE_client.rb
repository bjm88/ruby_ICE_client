require 'ruby_ICE_client/version'
require 'nokogiri'
require 'base64'

module RubyICEClient
  class << self
    def call(message, url)
      xml = Nokogiri::XML::Builder.new
      xml.Envelope {
        xml.Body {
          xml.evaluateAtSpecifiedTime('xmlns:ns2' => 'http://www.omg.org/spec/CDSS/201105/dss') {
            xml.interactionId(scopingEntityId: 'gov.nyc.health', interactionId: '123456')
            xml.specifiedTime "#{Date.today.strftime('%Y-%m-%d')}"
            xml.evaluationRequest(clientLanguage: '', clientTimeZoneOffset: '') {
              xml.kmEvaluationRequest {
                xml.kmId(scopingEntityId: 'org.nyc.cir', businessId: 'ICE', version: '1.0.0')
              }
              xml.dataRequirementItemData {
                xml.driId(itemId: 'cdsPayload') {
                  xml.containingEntityId(scopingEntityId: 'gov.nyc.health', businessId: 'ICEData', version: '1.0.0.0')
                }
                xml.data {
                  xml.informationModelSSId(scopingEntityId: 'org.opencds.vmr', businessId: 'VMR', version: '1.0')
                  xml.base64EncodedPayload Base64.encode64 message
                }
              }
            }
          }
        }
      }
      ns = xml.doc.root.add_namespace_definition 'S', 'http://www.w3.org/2003/05/soap-envelope'
      xml.doc.root.namespace = ns
      xml.doc.root.child.namespace = ns
      ns2 = xml.doc.root.child.child.add_namespace_definition 'ns2', 'http://www.w3.org/2003/05/soap-envelope'
      xml.doc.root.child.child.namespace = ns2

      uri = URI.parse url
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.open_timeout = ENV['ICE_OPEN_TIMEOUT'] || 30
      http.read_timeout = ENV['ICE_READ_TIMEOUT'] || 30
      http.ssl_timeout = ENV['ICE_SSL_TIMEOUT'] || 30
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new uri.path
      request.body = xml.to_xml
      response = http.request request
      response_xml = Nokogiri::XML response.body
      puts "#{response_xml}"
      output_message_node = response_xml.xpath '//evaluationResponse//base64EncodedPayload' if response_xml.present?
      if output_message_node.present? && output_message_node.first.present?
        return Base64.decode64 output_message_node.first.text
      else
        return nil
      end
    end
  end
end
