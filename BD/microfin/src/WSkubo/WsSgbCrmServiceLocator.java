/**
 * WsSgbCrmServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package WSkubo;

import soporte.bean.UsuarioBean;
import general.bean.ParametrosSesionBean;
import general.dao.ParametrosAplicacionDAO;
import general.servicio.ParametrosAplicacionServicio;
import general.servicio.ParametrosAplicacionServicio.Enum_Con_ParAplicacion;
import herramientas.Utileria;

public class WsSgbCrmServiceLocator extends org.apache.axis.client.Service implements WSkubo.WsSgbCrmService {
	
    public WsSgbCrmServiceLocator() {
    }


    public WsSgbCrmServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public WsSgbCrmServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }
    
    
    // Use to get a proxy class for WsSgbCrm
     private java.lang.String WsSgbCrm_address = "http://srvAppSGB:8080/SGB/services/WsSgbCrm";
    
   
     public java.lang.String getWsSgbCrmAddress() {
         return WsSgbCrm_address;
     }	
   

    // The WSDD service name defaults to the port name.
    private java.lang.String WsSgbCrmWSDDServiceName = "WsSgbCrm";

    public java.lang.String getWsSgbCrmWSDDServiceName() {
        return WsSgbCrmWSDDServiceName;
    }

    public void setWsSgbCrmWSDDServiceName(java.lang.String name) {
        WsSgbCrmWSDDServiceName = name;
    }

    public WSkubo.WsSgbCrm getWsSgbCrm() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(WsSgbCrm_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getWsSgbCrm(endpoint);
    }

    public WSkubo.WsSgbCrm getWsSgbCrm(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
        	WSkubo.WsSgbCrmSoapBindingStub _stub = new WSkubo.WsSgbCrmSoapBindingStub(portAddress, this);
            _stub.setPortName(getWsSgbCrmWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setWsSgbCrmEndpointAddress(java.lang.String address) {
        WsSgbCrm_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (WSkubo.WsSgbCrm.class.isAssignableFrom(serviceEndpointInterface)) {
            	WSkubo.WsSgbCrmSoapBindingStub _stub = new WSkubo.WsSgbCrmSoapBindingStub(new java.net.URL(WsSgbCrm_address), this);
                _stub.setPortName(getWsSgbCrmWSDDServiceName());
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
        if ("WsSgbCrm".equals(inputPortName)) {
            return getWsSgbCrm();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://webServices.soa.com", "WsSgbCrmService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://webServices.soa.com", "WsSgbCrm"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("WsSgbCrm".equals(portName)) {
            setWsSgbCrmEndpointAddress(address);
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
