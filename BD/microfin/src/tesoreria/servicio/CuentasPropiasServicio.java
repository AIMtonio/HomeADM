package tesoreria.servicio;

import tesoreria.bean.CuentasPropiasBean;
import tesoreria.dao.CuentasPropiasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CuentasPropiasServicio extends BaseServicio {

	
	CuentasPropiasDAO cuentasPropiasDAO = null;	
	public static interface Enum_Tra_Cuentas {
		int alta = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CuentasPropiasBean cuentasPropiasBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
			case Enum_Tra_Cuentas.alta:		
				mensaje = altaCuentasPropias(cuentasPropiasBean);
				break;
		}
		return mensaje;
	}
 
	public MensajeTransaccionBean altaCuentasPropias(CuentasPropiasBean cuentasPropiasBean){
		MensajeTransaccionBean mensaje = null;
		try{
			mensaje = cuentasPropiasDAO.altaCuentasPropias(cuentasPropiasBean);
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas propias", e);
		}
		
		return mensaje;
	}

	public CuentasPropiasDAO getCuentasPropiasDAO() {
		return cuentasPropiasDAO;
	}

	public void setCuentasPropiasDAO(CuentasPropiasDAO cuentasPropiasDAO) {
		this.cuentasPropiasDAO = cuentasPropiasDAO;
	}

	
}
