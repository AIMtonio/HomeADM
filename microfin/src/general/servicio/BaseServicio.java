package general.servicio;

import general.bean.ParametrosAuditoriaBean;

import org.apache.log4j.Logger;

public class BaseServicio {
	
 	protected ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	protected final Logger loggerISOTRX = Logger.getLogger("ISOTRX");
	
	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	} 
	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
}
