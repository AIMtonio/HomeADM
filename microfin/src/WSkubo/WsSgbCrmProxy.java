package WSkubo;

public class WsSgbCrmProxy implements WSkubo.WsSgbCrm {
  private String _endpoint = null;
  private WSkubo.WsSgbCrm wsSgbCrm = null;
  
  public WsSgbCrmProxy() {
    _initWsSgbCrmProxy();
  }
  
  public WsSgbCrmProxy(String endpoint) {
    _endpoint = endpoint;
    _initWsSgbCrmProxy();
  }
  
  private void _initWsSgbCrmProxy() {
    try {
      wsSgbCrm = (new WSkubo.WsSgbCrmServiceLocator()).getWsSgbCrm();
      if (wsSgbCrm != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)wsSgbCrm)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)wsSgbCrm)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (wsSgbCrm != null)
      ((javax.xml.rpc.Stub)wsSgbCrm)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public WSkubo.WsSgbCrm getWsSgbCrm() {
    if (wsSgbCrm == null)
      _initWsSgbCrmProxy();
    return wsSgbCrm;
  }
  
  public WSkubo.responses.WsSgbResponse paymentNotification(java.lang.String creditNumber) throws java.rmi.RemoteException{
    if (wsSgbCrm == null)
      _initWsSgbCrmProxy();
    return wsSgbCrm.paymentNotification(creditNumber);
  }
  
  
}