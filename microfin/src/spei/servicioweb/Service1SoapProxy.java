package spei.servicioweb;

import herramientas.Utileria;

import javax.xml.rpc.Stub;

public class Service1SoapProxy implements spei.servicioweb.Service1Soap {
  private String _endpoint = null;
  private String _timeout = null;
  private String _portWS = null;
  private spei.servicioweb.Service1Soap service1Soap = null;

  public Service1SoapProxy() {
  }

  public void _ConfService1SoapProxy(String endpoint, String portWS, String timeout) {
    this._endpoint = endpoint;
    this._timeout = timeout;
    this._portWS = portWS;
  }

  private void _initService1SoapProxy() {
    try {
    	Service1Locator serverLocator = new Service1Locator();
    	serverLocator.configuracion(_endpoint, _portWS);
    	service1Soap = serverLocator.getService1Soap();
      if (service1Soap != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)service1Soap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)service1Soap)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
		if(_timeout!=null)
			((javax.xml.rpc.Stub)service1Soap)._setProperty("axis.connection.timeout", Utileria.convierteEntero(_timeout));
		else
			_timeout = Integer.toString((Integer)((javax.xml.rpc.Stub)service1Soap)._getProperty("axis.connection.timeout"));
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }

  public String getEndpoint() {
    return _endpoint;
  }

  public void setEndpoint() {
    if (service1Soap != null) {
        ((javax.xml.rpc.Stub)service1Soap)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        ((javax.xml.rpc.Stub)service1Soap)._setProperty("axis.connection.timeout", Utileria.convierteEntero(_timeout));
    }
  }

  public spei.servicioweb.Service1Soap getService1Soap() {
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap;
  }

  public java.lang.String contrataciones(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException{
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.contrataciones(cadena, datos, corresponsales, ruta_ejecutar);
  }

  public java.lang.String info(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException{
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.info(cadena, datos, corresponsales, ruta_ejecutar);
  }

  public java.lang.String logs(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException{
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.logs(cadena, datos, corresponsales, ruta_ejecutar);
  }

  public java.lang.String devolucion(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException{
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.devolucion(cadena, datos, corresponsales, ruta_ejecutar);
  }

  public java.lang.String notificaciones(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException{
    if (service1Soap == null)
	  _initService1SoapProxy();
    return service1Soap.notificaciones(cadena, datos, corresponsales, ruta_ejecutar);
  }

  public java.lang.String reportaPago(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException{
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.reportaPago(cadena, datos, corresponsales, ruta_ejecutar);
  }

  public java.lang.String reverso(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException{
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.reverso(cadena, datos, corresponsales, ruta_ejecutar);
  }

  public java.lang.String generaClave(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException{
    if (service1Soap == null)
      _initService1SoapProxy();
    return service1Soap.generaClave(cadena, datos, corresponsales, ruta_ejecutar);
  }
}