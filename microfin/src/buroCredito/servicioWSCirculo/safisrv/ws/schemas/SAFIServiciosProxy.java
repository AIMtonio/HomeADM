package buroCredito.servicioWSCirculo.safisrv.ws.schemas;

public class SAFIServiciosProxy implements buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServicios {
  private String _endpoint = null;
  private buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServicios sAFIServicios = null;
  
  public SAFIServiciosProxy() {
    _initSAFIServiciosProxy();
  }
  
  public SAFIServiciosProxy(String endpoint) {
    _endpoint = endpoint;
    _initSAFIServiciosProxy();
  }
  
  private void _initSAFIServiciosProxy() {
    try {
      sAFIServicios = (new buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServiciosServiceLocator()).getSAFIServiciosSoap11();
      if (sAFIServicios != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)sAFIServicios)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)sAFIServicios)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (sAFIServicios != null)
      ((javax.xml.rpc.Stub)sAFIServicios)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServicios getSAFIServicios() {
    if (sAFIServicios == null)
      _initSAFIServiciosProxy();
    return sAFIServicios;
  }
  
  public buroCredito.servicioWSCirculo.safisrv.ws.schemas.ConsultaCirculoCreditoResponse consultaCirculoCredito(buroCredito.servicioWSCirculo.safisrv.ws.schemas.ConsultaCirculoCreditoRequest consultaCirculoCreditoRequest) throws java.rmi.RemoteException{
    if (sAFIServicios == null)
      _initSAFIServiciosProxy();
    return sAFIServicios.consultaCirculoCredito(consultaCirculoCreditoRequest);
  }
  
  
}