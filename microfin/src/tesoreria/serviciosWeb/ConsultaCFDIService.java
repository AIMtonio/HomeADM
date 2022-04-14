/**
 * ConsultaCFDIService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package tesoreria.serviciosWeb;
import java.net.URL;

import javax.xml.rpc.Service;
import javax.xml.rpc.ServiceException;
public interface ConsultaCFDIService extends Service {
    public String getBasicHttpBinding_IConsultaCFDIServiceAddress();

    public IConsultaCFDIService getBasicHttpBinding_IConsultaCFDIService() throws ServiceException;

    public IConsultaCFDIService getBasicHttpBinding_IConsultaCFDIService(URL portAddress) throws ServiceException;
}
