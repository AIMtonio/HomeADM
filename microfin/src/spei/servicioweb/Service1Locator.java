/**
 * Service1Locator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package spei.servicioweb;

import soporte.PropiedadesSAFIBean;
import soporte.dao.ParamGeneralesDAO;
import soporte.bean.ParamGeneralesBean;

public class Service1Locator extends org.apache.axis.client.Service implements spei.servicioweb.Service1 {

	private ParamGeneralesDAO paramGeneralesDAO = null;
	String urlWS	= "";
	String portWS	= "";

    public Service1Locator() {
//    	inicializaVariablesParametrizadas();
//    	System.out.println("Se inicializan las varibles...");
    }


    public Service1Locator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public Service1Locator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }
    
 // Use to get a proxy class for Service1Soap
    private java.lang.String Service1Soap_address = null; //PropiedadesSAFIBean.propiedadesSAFI.getProperty("urlIncorporate");//urlWS;

    public java.lang.String getService1SoapAddress() {
        return Service1Soap_address;
    }
    
    public void setService1SoapEndpointAddress(java.lang.String address) {
        Service1Soap_address = address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String Service1SoapWSDDServiceName = null; //PropiedadesSAFIBean.propiedadesSAFI.getProperty("portIncorporate"); //portWS;

    public java.lang.String getService1SoapWSDDServiceName() {
        return Service1SoapWSDDServiceName;
    }

    public void setService1SoapWSDDServiceName(java.lang.String name) {
        Service1SoapWSDDServiceName = name;
    }
    
    public void configuracion(String urlWS, String portWS){
    	ParamGeneralesBean paramGenerales = new ParamGeneralesBean();
		int consultaURL		= 47;
		int consultsPort	= 48;
		//urlWS	= paramGeneralesDAO.consultaPrincipal(paramGenerales, consultaURL).getValorParametro();
		//portWS	= paramGeneralesDAO.consultaPrincipal(paramGenerales, consultsPort).getValorParametro();
		//System.out.println("Se cargan las propiedades...");
		//urlWS	= PropiedadesSAFIBean.propiedadesSAFI.getProperty("urlIncorporate");
		//System.out.println("urlWSSS: " + urlWS);
		//portWS	= PropiedadesSAFIBean.propiedadesSAFI.getProperty("portIncorporate");
		
		this.Service1Soap_address = urlWS;
		this.Service1SoapWSDDServiceName = portWS;
		
		System.out.println("Service1Soap_address: " + Service1Soap_address);
		System.out.println("Service1SoapWSDDServiceName: " + Service1SoapWSDDServiceName);
    }

    public spei.servicioweb.Service1Soap getService1Soap() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(Service1Soap_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getService1Soap(endpoint);
    }

    public spei.servicioweb.Service1Soap getService1Soap(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
        	spei.servicioweb.Service1SoapStub _stub = new spei.servicioweb.Service1SoapStub(portAddress, this);
            _stub.setPortName(getService1SoapWSDDServiceName());
            System.out.println("_stub.getPortName(): " +_stub.getPortName()); 
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (spei.servicioweb.Service1Soap.class.isAssignableFrom(serviceEndpointInterface)) {
            	spei.servicioweb.Service1SoapStub _stub = new spei.servicioweb.Service1SoapStub(new java.net.URL(Service1Soap_address), this);
                _stub.setPortName(getService1SoapWSDDServiceName());
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
        if ("Service1Soap".equals(inputPortName)) {
            return getService1Soap();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://tempuri.org/", "Service12");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://tempuri.org/", "Service1Soap"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
    	if ("Service1Soap".equals(portName)) {
            setService1SoapEndpointAddress(address);
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


	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}


	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}

}
