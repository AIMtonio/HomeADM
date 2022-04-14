package soporte.servicioweb;

public class SmartwebTimbradoRetencionesProxy implements SmartwebTimbradoRetenciones {
  private String _endpoint = null;
  private SmartwebTimbradoRetenciones iwcfTimbradoRetenciones = null;
  
  public SmartwebTimbradoRetencionesProxy() {
    _initIwcfTimbradoRetencionesProxy();
  }
  
  public SmartwebTimbradoRetencionesProxy(String endpoint) {
    _endpoint = endpoint;
    _initIwcfTimbradoRetencionesProxy();
  }
  
  private void _initIwcfTimbradoRetencionesProxy() {
    try {
      iwcfTimbradoRetenciones = (new SmartwebTimbradoRetencionesLocator()).getwcfTimbradoRetencionesEndpoint1();
      if (iwcfTimbradoRetenciones != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)iwcfTimbradoRetenciones)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)iwcfTimbradoRetenciones)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (iwcfTimbradoRetenciones != null)
      ((javax.xml.rpc.Stub)iwcfTimbradoRetenciones)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public SmartwebTimbradoRetenciones getIwcfTimbradoRetenciones() {
    if (iwcfTimbradoRetenciones == null)
      _initIwcfTimbradoRetencionesProxy();
    return iwcfTimbradoRetenciones;
  }
  
  public java.lang.String timbrarRetencionXML(java.lang.String xmlRetencion, java.lang.String tokenAutenticacion) throws java.rmi.RemoteException{
    if (iwcfTimbradoRetenciones == null)
      _initIwcfTimbradoRetencionesProxy();
    return iwcfTimbradoRetenciones.timbrarRetencionXML(xmlRetencion, tokenAutenticacion);
  }
  
  public java.lang.String timbrarRetencionXMLV2(java.lang.String xmlRetencion, java.lang.String tokenAutenticacion) throws java.rmi.RemoteException{
    if (iwcfTimbradoRetenciones == null)
      _initIwcfTimbradoRetencionesProxy();
    return iwcfTimbradoRetenciones.timbrarRetencionXMLV2(xmlRetencion, tokenAutenticacion);
  }
  
  
}