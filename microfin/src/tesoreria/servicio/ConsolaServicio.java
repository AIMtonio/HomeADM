package tesoreria.servicio;

import java.util.List;
import java.util.Map;

import general.servicio.BaseServicio;
import herramientas.Utileria;
import tesoreria.bean.ConsolaBean;
import tesoreria.dao.ConsolaDAO;

public class ConsolaServicio extends BaseServicio{
	
	ConsolaDAO consolaDAO = null;
	
	//Metodo para obtener todo el concentrado de la informacion de la consola 
	public ConsolaBean obtieneConcentrado(ConsolaBean consola){
		
		ConsolaBean consolaBean = null;
		
		double totalEfectivo = 0;
		double totalCirculante = 0;
		double totalInmediato=0;
		double totalAutorizado=0;
	
		consolaBean = consolaDAO.consultaConcentrado(consola.getSucursalID(), consola.getFechadia());
		
		totalEfectivo = Utileria.convierteDoble(consolaBean.getCuentasBancos()) + Utileria.convierteDoble(consolaBean.getEfectivoCaja());
		consolaBean.setTotalEfectivo(String.valueOf(totalEfectivo));
		
		totalCirculante = Utileria.convierteDoble(consolaBean.getInversionBancarias()) + Utileria.convierteDoble(consolaBean.getMontoCreVencidos()) +  totalEfectivo;
		consolaBean.setTotalCirculante(String.valueOf(totalCirculante));
		
		totalInmediato = Utileria.convierteDoble(consolaBean.getDesPendientesDis()) + Utileria.convierteDoble(consolaBean.getGastosPendientes()) + Utileria.convierteDoble(consolaBean.getVencimientoFonde()) + Utileria.convierteDoble(consolaBean.getPagoInteresCaptacion());
		consolaBean.setTotalComproInme(String.valueOf(totalInmediato));
		
		totalAutorizado = Utileria.convierteDoble(consolaBean.getPresuGasAuto()) + totalInmediato;
		consolaBean.setTotalComproAut(String.valueOf(totalAutorizado));
		
		return consolaBean;
	}
	
	
	//Metodo que regresa una lista con un mapa de todos los campos de la consulta
	public List obtieneDetalleConsola(ConsolaBean consola){
		
		List<Map<String, Object>> list = null;

		list = consolaDAO.detalleConsola(consola.getSucursalID(), consola.getFechadia(), Utileria.convierteEntero(consola.getTipoConsulta()));
		
		return list;
	}
	
	public ConsolaDAO getConsolaDAO() {
		return consolaDAO;
	}

	public void setConsolaDAO(ConsolaDAO consolaDAO) {
		this.consolaDAO = consolaDAO;
	}

}
