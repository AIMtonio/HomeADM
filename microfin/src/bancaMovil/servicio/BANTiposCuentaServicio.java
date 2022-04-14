package bancaMovil.servicio;

import java.util.List;

import bancaMovil.bean.BanTiposCuentaBean;
import bancaMovil.dao.BANTiposCuentasDAO;
import bancaMovil.servicio.BAMCuentasOrigenServicio.Enum_Lis_CuentasOrigen;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class BANTiposCuentaServicio extends BaseServicio {
	BANTiposCuentasDAO banTiposCuentasDAO = null;
	
	public static interface Enum_Lis_TipoCuenta {
		int principal 		= 1;
	}
	public static interface Enum_Tra_TiposCuenta  {
		int alta		 = 1;
		int baja		 = 2;
	}
		
	public BANTiposCuentaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public MensajeTransaccionBean grabaTiposCuenta(int tipoTransaccion, BanTiposCuentaBean banTiposCuentaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
		case Enum_Tra_TiposCuenta.alta:
			mensaje = banTiposCuentasDAO.altaBanTiposCuenta(banTiposCuentaBean);
			break;
		case Enum_Tra_TiposCuenta.baja:
			mensaje = banTiposCuentasDAO.bajaBanTiposCuentas();
			break;
		}
		
		return mensaje;	
	}
	public List lista(int tipoLista){		
		List listaBANTipoCuenta = null;
		switch (tipoLista) {
			case Enum_Lis_CuentasOrigen.principal:		
				listaBANTipoCuenta = banTiposCuentasDAO.listaBanTiposCuenta( tipoLista);				
				break;
		}
		return listaBANTipoCuenta;
	}

	public BANTiposCuentasDAO getBANTiposCuentasDAO() {
		return banTiposCuentasDAO;
	}

	public void setBANTiposCuentasDAO(BANTiposCuentasDAO banTiposCuentasDAO) {
		this.banTiposCuentasDAO = banTiposCuentasDAO;
	}
	
}
