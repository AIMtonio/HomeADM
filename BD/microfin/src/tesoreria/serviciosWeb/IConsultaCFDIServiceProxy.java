package tesoreria.serviciosWeb;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;
import javax.xml.rpc.Stub;

import tesoreria.bean.Acuse;
public class IConsultaCFDIServiceProxy implements IConsultaCFDIService {
  private String _endpoint = null;
  private String _timeout = null;
  private IConsultaCFDIService iConsultaCFDIService = null;
  
  public IConsultaCFDIServiceProxy() {
    _initIConsultaCFDIServiceProxy();
  }
  
  public IConsultaCFDIServiceProxy(String endpoint,String timeout) {
    _endpoint = endpoint;
    _timeout = timeout;
    _initIConsultaCFDIServiceProxy();
  }
  
  private void _initIConsultaCFDIServiceProxy() {
    try {
    	ConsultaCFDIServiceLocator serviceLocator = new ConsultaCFDIServiceLocator(); 
    	serviceLocator.setBasicHttpBinding_IConsultaCFDIServiceAddress(_endpoint);
      iConsultaCFDIService = serviceLocator.getBasicHttpBinding_IConsultaCFDIService();
      if (iConsultaCFDIService != null) {
        if (_endpoint != null){
          ((Stub)iConsultaCFDIService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        }else{
          _endpoint = (String)((Stub)iConsultaCFDIService)._getProperty("javax.xml.rpc.service.endpoint.address");
        }
      }
      
      if(_timeout != null)
    	  ((Stub)iConsultaCFDIService)._setProperty("TIMEOUT",_timeout);
      else
    	  ((Stub)iConsultaCFDIService)._getProperty("TIMEOUT");
    }
    catch (ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint,String timeout) {
    _endpoint = endpoint;
    _timeout = timeout;
    if (iConsultaCFDIService != null){
    	((Stub)iConsultaCFDIService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    	((Stub)iConsultaCFDIService)._setProperty("TIMEOUT",_timeout);
    }
  }
  
  public IConsultaCFDIService getIConsultaCFDIService() {
    if (iConsultaCFDIService == null)
      _initIConsultaCFDIServiceProxy();
    return iConsultaCFDIService;
  }
  
  public Acuse consulta(String expresionImpresa) throws RemoteException{
	  
    if (iConsultaCFDIService == null)
      _initIConsultaCFDIServiceProxy();
    return iConsultaCFDIService.consulta(expresionImpresa);
  }
  
  
}