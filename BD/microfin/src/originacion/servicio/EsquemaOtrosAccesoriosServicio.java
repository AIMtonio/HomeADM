package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import originacion.bean.CreditosPlazosBean;
import originacion.bean.EsquemaOtrosAccesoriosBean;
import originacion.dao.EsquemaOtrosAccesoriosDAO;


public class EsquemaOtrosAccesoriosServicio extends BaseServicio{
	
	EsquemaOtrosAccesoriosDAO esquemaOtrosAccesoriosDAO;

	private EsquemaOtrosAccesoriosServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int alta = 1;
		int modifica = 2;
		int alta_Grid = 3;
	}
	
	public static interface Enum_Consulta {
		int principal = 1;	// Consulta los accesorios cobrados por producto de crédito
		int accesoriosCred	= 2; // Consulta los datos generales de los accesorios por crédito
	}
	
	public static interface Enum_Lista{
		int plazos = 1;
		int listaAccesorios = 2;
		int listaAccesoriosCred = 3;
		int listaCombo		= 4;
		int listaAccesSolicid	= 5;
		int listaDesgloseSim	= 6;
	}
	
	/**
	 * 
	 * @param tipoTransaccion: Da de alta los Esquemas de Accesorios por Producto de Crédito
	 * @param otrosAccesoriosBean
	 * @param detalles
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaOtrosAccesoriosBean esquemaOtrosAccesoriosBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Transaccion.alta:
			mensaje = esquemaOtrosAccesoriosDAO.alta(esquemaOtrosAccesoriosBean);
			break;
		case Enum_Transaccion.modifica:
			mensaje = esquemaOtrosAccesoriosDAO.modifica(esquemaOtrosAccesoriosBean);
			break;
		case Enum_Transaccion.alta_Grid:
			mensaje = esquemaOtrosAccesoriosDAO.altaPlazosMonto(esquemaOtrosAccesoriosBean);
			break;
		}
		return mensaje;
	}
	
	/**
	 * 
	 * @param tipoConsulta: Método para consultar esquema otros accesorios
	 * @param esquemaOtrosAccesorios
	 * @return
	 */
	public EsquemaOtrosAccesoriosBean consulta(int tipoConsulta, EsquemaOtrosAccesoriosBean esquemaOtrosAccesorios){
		EsquemaOtrosAccesoriosBean esquemaAccesoriosCon = null;
		try{
			switch(tipoConsulta){
			case Enum_Consulta.principal:
				esquemaAccesoriosCon = esquemaOtrosAccesoriosDAO.consulta(esquemaOtrosAccesorios,tipoConsulta);
				break;
			
			case Enum_Consulta.accesoriosCred:
				esquemaAccesoriosCon = esquemaOtrosAccesoriosDAO.consultaDatosAc(esquemaOtrosAccesorios,tipoConsulta);
				break;
			}
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
		
		return esquemaAccesoriosCon;
	}
	
	public List<EsquemaOtrosAccesoriosBean> lista(int tipoLista, EsquemaOtrosAccesoriosBean esquemaOtrosAcceosorios){
		List<EsquemaOtrosAccesoriosBean> lista = null;
		switch(tipoLista){
		case Enum_Lista.plazos:
			lista = esquemaOtrosAccesoriosDAO.lista(esquemaOtrosAcceosorios,tipoLista);
			break;
		case Enum_Lista.listaAccesorios:
			lista = esquemaOtrosAccesoriosDAO.listaAc(esquemaOtrosAcceosorios, tipoLista);
			break;
		
		case Enum_Lista.listaAccesoriosCred:
			lista = esquemaOtrosAccesoriosDAO.listaAccesoriosCred(esquemaOtrosAcceosorios, tipoLista);
			break;
		case Enum_Lista.listaDesgloseSim:
			lista = esquemaOtrosAccesoriosDAO.listaDesgloseAccSim(tipoLista, esquemaOtrosAcceosorios);
			break;
		}
		return lista;
	}
	
	public Object[] listaCombo(int tipoLista, EsquemaOtrosAccesoriosBean esquemaOtrosAccesoriosBean){
		List<CreditosPlazosBean> listaPlazos = null;
		switch (tipoLista) {
			case Enum_Lista.listaCombo:		
				listaPlazos=  esquemaOtrosAccesoriosDAO.listaCombo(esquemaOtrosAccesoriosBean,tipoLista);				
				break;
			case Enum_Lista.listaAccesSolicid:
				listaPlazos = esquemaOtrosAccesoriosDAO.listaCombo(esquemaOtrosAccesoriosBean, tipoLista);
				break;
		}		
		return listaPlazos.toArray();
	}
	
	public EsquemaOtrosAccesoriosDAO getEsquemaOtrosAccesoriosDAO() {
		return esquemaOtrosAccesoriosDAO;
	}

	public void setEsquemaOtrosAccesoriosDAO(
			EsquemaOtrosAccesoriosDAO esquemaOtrosAccesoriosDAO) {
		this.esquemaOtrosAccesoriosDAO = esquemaOtrosAccesoriosDAO;
	}
}
