/**
 * ConsultaCFDIServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package tesoreria.serviciosWeb;
import org.apache.axis.AxisFault;
import org.apache.axis.client.Service;
import org.apache.axis.client.Stub;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;

import javax.xml.namespace.QName;
import javax.xml.rpc.ServiceException;

import java.net.URL;
import java.net.MalformedURLException;
import java.rmi.Remote;
import java.util.HashSet;


public class ConsultaCFDIServiceLocator extends Service implements ConsultaCFDIService {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ConsultaCFDIServiceLocator() {
    }


    public ConsultaCFDIServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ConsultaCFDIServiceLocator(String wsdlLoc, QName sName) throws ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for BasicHttpBinding_IConsultaCFDIService
    private String BasicHttpBinding_IConsultaCFDIService_address = "";//"https://consultaqr.facturaelectronica.sat.gob.mx/ConsultaCFDIService.svc";

    public String getBasicHttpBinding_IConsultaCFDIServiceAddress() {
        return BasicHttpBinding_IConsultaCFDIService_address;
    }
    
    public void setBasicHttpBinding_IConsultaCFDIServiceAddress(String endPoint) {
         BasicHttpBinding_IConsultaCFDIService_address = endPoint;
    }
    
    // The WSDD service name defaults to the port name.
    private String BasicHttpBinding_IConsultaCFDIServiceWSDDServiceName = "BasicHttpBinding_IConsultaCFDIService";

    public String getBasicHttpBinding_IConsultaCFDIServiceWSDDServiceName() {
        return BasicHttpBinding_IConsultaCFDIServiceWSDDServiceName;
    }

    public void setBasicHttpBinding_IConsultaCFDIServiceWSDDServiceName(String name) {
        BasicHttpBinding_IConsultaCFDIServiceWSDDServiceName = name;
    }

    public IConsultaCFDIService getBasicHttpBinding_IConsultaCFDIService() throws ServiceException {
    		URL endpoint;
        try {

            endpoint = new URL(BasicHttpBinding_IConsultaCFDIService_address);
        }
        catch (MalformedURLException e) {
            throw new ServiceException(e);
        }
        return getBasicHttpBinding_IConsultaCFDIService(endpoint);
    }

    public IConsultaCFDIService getBasicHttpBinding_IConsultaCFDIService(URL portAddress) throws ServiceException {
        try {
            BasicHttpBinding_IConsultaCFDIServiceStub _stub = new BasicHttpBinding_IConsultaCFDIServiceStub(portAddress, this);
            _stub.setPortName(getBasicHttpBinding_IConsultaCFDIServiceWSDDServiceName());
            return _stub;
        }
        catch (AxisFault e) {
            return null;
        }
    }

    public void setBasicHttpBinding_IConsultaCFDIServiceEndpointAddress(String address) {
        BasicHttpBinding_IConsultaCFDIService_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public Remote getPort(Class serviceEndpointInterface) throws ServiceException {
        try {
            if (IConsultaCFDIService.class.isAssignableFrom(serviceEndpointInterface)) {
                BasicHttpBinding_IConsultaCFDIServiceStub _stub = new BasicHttpBinding_IConsultaCFDIServiceStub(new URL(BasicHttpBinding_IConsultaCFDIService_address), this);
                _stub.setPortName(getBasicHttpBinding_IConsultaCFDIServiceWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new ServiceException(t);
        }
        throw new ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public Remote getPort(QName portName, Class serviceEndpointInterface) throws ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        String inputPortName = portName.getLocalPart();
        if ("BasicHttpBinding_IConsultaCFDIService".equals(inputPortName)) {
            return getBasicHttpBinding_IConsultaCFDIService();
        }
        else  {
            Remote _stub = getPort(serviceEndpointInterface);
            ( (Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public QName getServiceName() {
        return new QName("http://tempuri.org/", "ConsultaCFDIService");
    }

    private HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new HashSet();
            ports.add(new QName("http://tempuri.org/", "BasicHttpBinding_IConsultaCFDIService"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(String portName, String address) throws ServiceException {
        
		if ("BasicHttpBinding_IConsultaCFDIService".equals(portName)) {
		            setBasicHttpBinding_IConsultaCFDIServiceEndpointAddress(address);
		        }
		        else 
		{ // Unknown Port Name
		            throw new ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
		        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(QName portName, String address) throws ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
