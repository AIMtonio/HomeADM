
package tarjetas.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import tarjetas.bean.TiposCuentaValidoTipoTarjetaBean;
import tarjetas.dao.TiposCuentaValidoTipoTarjetaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TiposCuentaValidoTipoTarjetaServicio extends BaseServicio{	
	TiposCuentaValidoTipoTarjetaDAO tiposCuentaValidoTipoTarjetaDAO =null;

	public TiposCuentaValidoTipoTarjetaServicio() {
		super();
	}
	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Tra_CtaValidoTipoTar {
		int alta = 1;
		int modificacion=2;
	}
	public static interface Enum_Lis_tipoCuentaTar {
		int listaConsulta = 1;
	}
	public static interface Enum_Con_CtaValidoTipoTar{
		
        int principal  =1;
    }


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,TiposCuentaValidoTipoTarjetaBean tiposCuentaValidoTipoTarjetaBean){
		
		ArrayList listaTipoCuenta = (ArrayList) creaListaDetalle(tiposCuentaValidoTipoTarjetaBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
		 case Enum_Tra_CtaValidoTipoTar.alta:	
				mensaje = tiposCuentaValidoTipoTarjetaDAO.grabaGiroNegocio(tiposCuentaValidoTipoTarjetaBean,listaTipoCuenta);									
				break;	
		 case Enum_Tra_CtaValidoTipoTar.modificacion:
		   mensaje = tiposCuentaValidoTipoTarjetaDAO.modificarTipoCuenta(tiposCuentaValidoTipoTarjetaBean,listaTipoCuenta);
		   break;
		}
		return mensaje;
	}

	private List creaListaDetalle(TiposCuentaValidoTipoTarjetaBean tiposCuentaValidoTipoTarjetaBean){
		StringTokenizer tokensTipoCuenta = new StringTokenizer(tiposCuentaValidoTipoTarjetaBean.getTipoCuenta(), ",");

		ArrayList listaDias = new ArrayList();
		TiposCuentaValidoTipoTarjetaBean ValidoTipoTarjetaBean;
		String tipoCuenta[] = new String[tokensTipoCuenta.countTokens()];   // Checar para guardar caracteres
		
		int i=0;
		while(tokensTipoCuenta.hasMoreTokens()){
			tipoCuenta[i] = String.valueOf(tokensTipoCuenta.nextToken());
			i++;
		}
		for(int contador=0; contador < tipoCuenta.length; contador++){
			ValidoTipoTarjetaBean = new TiposCuentaValidoTipoTarjetaBean();
			ValidoTipoTarjetaBean.setTipoTarjetaDebID(tiposCuentaValidoTipoTarjetaBean.getTipoTarjetaDebID());
		    ValidoTipoTarjetaBean.setTipoCuenta(String.valueOf(tipoCuenta[contador])); 	
		
			listaDias.add(ValidoTipoTarjetaBean);
		}
		return listaDias;
	}
	
	public  Object[] listaConsulta(int tipoConsulta, TiposCuentaValidoTipoTarjetaBean tiposCuentaValidoTipoTarjetaBean){
		List listSeguimiento = null;
		switch(tipoConsulta){
			case Enum_Lis_tipoCuentaTar.listaConsulta:
				listSeguimiento = tiposCuentaValidoTipoTarjetaDAO.consultaTipoCuenta(tipoConsulta,tiposCuentaValidoTipoTarjetaBean);
			break;
			
		}
		return listSeguimiento.toArray();
	}

	public TiposCuentaValidoTipoTarjetaDAO getTiposCuentaValidoTipoTarjetaDAO() {
		return tiposCuentaValidoTipoTarjetaDAO;
	}
	public void setTiposCuentaValidoTipoTarjetaDAO(
			TiposCuentaValidoTipoTarjetaDAO tiposCuentaValidoTipoTarjetaDAO) {
		this.tiposCuentaValidoTipoTarjetaDAO = tiposCuentaValidoTipoTarjetaDAO;
	}
	
	//------------getter y setter--------------

}
