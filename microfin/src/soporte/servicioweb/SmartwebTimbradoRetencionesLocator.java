/**
 * WcfTimbradoRetencionesLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package soporte.servicioweb;

public class SmartwebTimbradoRetencionesLocator extends org.apache.axis.client.Service implements SmartwebTimbradoRetencionesBean {

    public SmartwebTimbradoRetencionesLocator() {
    }


    public SmartwebTimbradoRetencionesLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public SmartwebTimbradoRetencionesLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for wcfTimbradoRetencionesEndpoint1
    private java.lang.String wcfTimbradoRetencionesEndpoint1_address = "https://sufacturacion2t/Timbrado/wcfTimbradoRetenciones.svc";

    public java.lang.String getwcfTimbradoRetencionesEndpoint1Address() {
        return wcfTimbradoRetencionesEndpoint1_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String wcfTimbradoRetencionesEndpoint1WSDDServiceName = "wcfTimbradoRetencionesEndpoint1";

    public java.lang.String getwcfTimbradoRetencionesEndpoint1WSDDServiceName() {
        return wcfTimbradoRetencionesEndpoint1WSDDServiceName;
    }

    public void setwcfTimbradoRetencionesEndpoint1WSDDServiceName(java.lang.String name) {
        wcfTimbradoRetencionesEndpoint1WSDDServiceName = name;
    }

    public SmartwebTimbradoRetenciones getwcfTimbradoRetencionesEndpoint1() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(wcfTimbradoRetencionesEndpoint1_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getwcfTimbradoRetencionesEndpoint1(endpoint);
    }

    public SmartwebTimbradoRetenciones getwcfTimbradoRetencionesEndpoint1(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            SmartwebTimbradoRetencionesEndpoint1Stub _stub = new SmartwebTimbradoRetencionesEndpoint1Stub(portAddress, this);
            _stub.setPortName(getwcfTimbradoRetencionesEndpoint1WSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setwcfTimbradoRetencionesEndpoint1EndpointAddress(java.lang.String address) {
        wcfTimbradoRetencionesEndpoint1_address = address;
    }


    // Use to get a proxy class for wcfTimbradoRetencionesEndpoint
    private java.lang.String wcfTimbradoRetencionesEndpoint_address = "http://pruebascfdi.smartweb.com.mx/Timbrado/wcfTimbradoRetenciones.svc";

    public java.lang.String getwcfTimbradoRetencionesEndpointAddress() {
        return wcfTimbradoRetencionesEndpoint_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String wcfTimbradoRetencionesEndpointWSDDServiceName = "wcfTimbradoRetencionesEndpoint";

    public java.lang.String getwcfTimbradoRetencionesEndpointWSDDServiceName() {
        return wcfTimbradoRetencionesEndpointWSDDServiceName;
    }

    public void setwcfTimbradoRetencionesEndpointWSDDServiceName(java.lang.String name) {
        wcfTimbradoRetencionesEndpointWSDDServiceName = name;
    }

    public SmartwebTimbradoRetenciones getwcfTimbradoRetencionesEndpoint() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(wcfTimbradoRetencionesEndpoint_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getwcfTimbradoRetencionesEndpoint(endpoint);
    }

    public SmartwebTimbradoRetenciones getwcfTimbradoRetencionesEndpoint(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            SmartwebTimbradoRetencionesEndpointStub _stub = new SmartwebTimbradoRetencionesEndpointStub(portAddress, this);
            _stub.setPortName(getwcfTimbradoRetencionesEndpointWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setwcfTimbradoRetencionesEndpointEndpointAddress(java.lang.String address) {
        wcfTimbradoRetencionesEndpoint_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     * This service has multiple ports for a given interface;
     * the proxy implementation returned may be indeterminate.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (SmartwebTimbradoRetenciones.class.isAssignableFrom(serviceEndpointInterface)) {
                SmartwebTimbradoRetencionesEndpoint1Stub _stub = new SmartwebTimbradoRetencionesEndpoint1Stub(new java.net.URL(wcfTimbradoRetencionesEndpoint1_address), this);
                _stub.setPortName(getwcfTimbradoRetencionesEndpoint1WSDDServiceName());
                return _stub;
            }
            if (SmartwebTimbradoRetenciones.class.isAssignableFrom(serviceEndpointInterface)) {
                SmartwebTimbradoRetencionesEndpointStub _stub = new SmartwebTimbradoRetencionesEndpointStub(new java.net.URL(wcfTimbradoRetencionesEndpoint_address), this);
                _stub.setPortName(getwcfTimbradoRetencionesEndpointWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("wcfTimbradoRetencionesEndpoint1".equals(inputPortName)) {
            return getwcfTimbradoRetencionesEndpoint1();
        }
        else if ("wcfTimbradoRetencionesEndpoint".equals(inputPortName)) {
            return getwcfTimbradoRetencionesEndpoint();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://tempuri.org/", "wcfTimbradoRetenciones");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://tempuri.org/", "wcfTimbradoRetencionesEndpoint1"));
            ports.add(new javax.xml.namespace.QName("http://tempuri.org/", "wcfTimbradoRetencionesEndpoint"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("wcfTimbradoRetencionesEndpoint1".equals(portName)) {
            setwcfTimbradoRetencionesEndpoint1EndpointAddress(address);
        }
        else 
if ("wcfTimbradoRetencionesEndpoint".equals(portName)) {
            setwcfTimbradoRetencionesEndpointEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
