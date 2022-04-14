package nomina.servicio;
import java.util.ArrayList;
import java.util.List;
import nomina.bean.CondicionProductoNominaBean;
import nomina.bean.NomEsquemaTasaCredBean;
import nomina.bean.NominaCondicionCredBean;

import nomina.dao.NomEsquemaTasaCredDAO;
import nomina.dao.NominaCondicionCredDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CondicionProductoNominaServicio extends BaseServicio{
	NominaCondicionCredDAO nominaCondicionCredDAO = null;
	NomEsquemaTasaCredDAO nomEsquemaTasaCredDAO = null;
	
	public static interface Enum_Tra_CondicionProducto{
		int altaCondicionesCred = 1;
		int altaEsquemasTasa = 2;
	
	}
	
	public static interface Enum_Lis_CondicionProducto{
		int listaCondicionesCred = 1;
		int listaEsqTasa =2;
	}
	
	public static interface Enum_Con_CondicionProducto{
		int principal = 1;
		int existeEsquemaT = 2;
		int existeCodicionProduc = 3;
		int consultaOriginacion = 4;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,CondicionProductoNominaBean condicionProductoNominaBean){
		MensajeTransaccionBean mensaje = null;
		
		switch(tipoTransaccion){
			case Enum_Tra_CondicionProducto.altaCondicionesCred:
				ArrayList<NominaCondicionCredBean> listaDetalleCred = (ArrayList<NominaCondicionCredBean>) detalleGridCredito(condicionProductoNominaBean);
				mensaje = nominaCondicionCredDAO.guardarCondicionesCredito(condicionProductoNominaBean, listaDetalleCred);
				break;
			case Enum_Tra_CondicionProducto.altaEsquemasTasa:
				ArrayList<NomEsquemaTasaCredBean> listaDetalleTasa = (ArrayList<NomEsquemaTasaCredBean>) detalleGridEsqTasa(condicionProductoNominaBean);
				mensaje = nomEsquemaTasaCredDAO.guardarEsquemasTasaCred(condicionProductoNominaBean, listaDetalleTasa);
				break;
		}
		
		return mensaje;
	}

	
	public List<?> lista(int tipoLista, CondicionProductoNominaBean condicionProductoNominaBean)
	{   
		NominaCondicionCredBean nominaCondicionCredBean = null;
		NomEsquemaTasaCredBean nomEsquemaTasaCredBean = null;
		List<?> resultado = null;
		
		switch(tipoLista){
		case Enum_Lis_CondicionProducto.listaCondicionesCred:
			nominaCondicionCredBean = new NominaCondicionCredBean();
			nominaCondicionCredBean.setConvenioNominaID(condicionProductoNominaBean.getConvenioNominaID());
			nominaCondicionCredBean.setInstitNominaID(condicionProductoNominaBean.getInstitNominaID());
			
			resultado = nominaCondicionCredDAO.listaGridNomCondicionCred(tipoLista, nominaCondicionCredBean);
			break;
		case Enum_Lis_CondicionProducto.listaEsqTasa:
			nomEsquemaTasaCredBean = new NomEsquemaTasaCredBean();
			nomEsquemaTasaCredBean.setCondicionCredID(condicionProductoNominaBean.getCondicionCredID());
			resultado = nomEsquemaTasaCredDAO.listaGridNomEsquemaTasaCred(tipoLista, nomEsquemaTasaCredBean);
			break;
		}
		return resultado;
	}
	
	
	public CondicionProductoNominaBean consulta(int tipoConsulta,  CondicionProductoNominaBean condicionProductoNominaBean){
		CondicionProductoNominaBean resultado = null;
		NominaCondicionCredBean almacen = null;
		NominaCondicionCredBean nominaCondicionCredRes = null;
		switch(tipoConsulta){
			case Enum_Con_CondicionProducto.principal:
				almacen = new NominaCondicionCredBean();
				nominaCondicionCredRes = new NominaCondicionCredBean();
				almacen.setCondicionCredID(condicionProductoNominaBean.getCondicionCredID());
				nominaCondicionCredRes = nominaCondicionCredDAO.consultaValorTasa(tipoConsulta, almacen);
				break;
			case Enum_Con_CondicionProducto.existeEsquemaT:
				almacen = new NominaCondicionCredBean();
				nominaCondicionCredRes = new NominaCondicionCredBean();
				almacen.setCondicionCredID(condicionProductoNominaBean.getCondicionCredID());
				nominaCondicionCredRes = nominaCondicionCredDAO.consultaCantEsquema(tipoConsulta, almacen);
				
				break;
			case Enum_Con_CondicionProducto.existeCodicionProduc:
				almacen = new NominaCondicionCredBean();
				nominaCondicionCredRes = new NominaCondicionCredBean();
				almacen.setCondicionCredID(condicionProductoNominaBean.getCondicionCredID());
				nominaCondicionCredRes = nominaCondicionCredDAO.conCoincidenciaCondicion(tipoConsulta, almacen);
				
				break;
				
			case Enum_Con_CondicionProducto.consultaOriginacion:
				almacen = new NominaCondicionCredBean();
				almacen.setCondicionCredID(condicionProductoNominaBean.getCondicionCredID());
				almacen.setInstitNominaID(condicionProductoNominaBean.getInstitNominaID());
				almacen.setProducCreditoID(condicionProductoNominaBean.getProducCreditoID());
				almacen.setConvenioNominaID(condicionProductoNominaBean.getConvenioNominaID());
				nominaCondicionCredRes = nominaCondicionCredDAO.consultaPorConvenio(tipoConsulta, almacen);
				
				break;			
		}
		
		if(nominaCondicionCredRes != null){
			resultado = new CondicionProductoNominaBean();
			resultado.setValorTasa(nominaCondicionCredRes.getValorTasa());
			resultado.setCantidad(nominaCondicionCredRes.getCantidad());
			resultado.setnCoincidencias(nominaCondicionCredRes.getnCoincidencias());
			resultado.setTipoCobMora(nominaCondicionCredRes.getTipoCobMora());
			resultado.setValorMora(nominaCondicionCredRes.getValorMora());
			
		}
		return resultado;
	}

	private List<NominaCondicionCredBean> detalleGridCredito(CondicionProductoNominaBean beanEntrada){
		List<String> listaCondiciones = beanEntrada.getLisCondicionCredID();
		List<String> listaProductosID = beanEntrada.getLisProducCreditoID();
		List<String> listaTiposTasa = beanEntrada.getLisTipoTasaCred();
		List<String> listaValoresTasa = beanEntrada.getLisValorTasaCred();
		List<String> listaTipoCobMora= beanEntrada.getLisTipoCobMora();
		List<String> listaValoresMora = beanEntrada.getLisValorMora();
		
		ArrayList<NominaCondicionCredBean> listaDetalle = new ArrayList<NominaCondicionCredBean>();
		
		NominaCondicionCredBean iterBean = null;
		int tamanio = 0;
		if(listaProductosID != null){
			tamanio = listaProductosID.size();
		}
		
		for(int fila = 0; fila < tamanio; fila++){
			iterBean = new NominaCondicionCredBean();
			iterBean.setCondicionCredID(listaCondiciones.get(fila));
			iterBean.setProducCreditoID(listaProductosID.get(fila));
			iterBean.setTipoTasa(listaTiposTasa.get(fila));
			iterBean.setValorTasa(listaValoresTasa.get(fila));
			if(listaValoresMora!=null)
			{
				iterBean.setTipoCobMora(listaTipoCobMora.get(fila));
				iterBean.setValorMora(listaValoresMora.get(fila));
			}
			else
			{
				iterBean.setTipoCobMora("D");
				iterBean.setValorMora("0.0");
			}
			listaDetalle.add(iterBean);
		}
		
		return listaDetalle;
	}
	
	
	
private List<NomEsquemaTasaCredBean> detalleGridEsqTasa(CondicionProductoNominaBean beanEntrada){
	
	List<String> listaSucursales = beanEntrada.getLisSucursalID();
	List<String> listaTiposEmpleados = beanEntrada.getLisTipoEmpleadoIDEsqTasa();
	List<String> listaPlazos = beanEntrada.getLisPlazoIDEsqTasa();
	List<String> listaMinCreds = beanEntrada.getLisMinCredEsqTasa();
	List<String> listaMaxCreds = beanEntrada.getLisMaxCredEsqTasa();
	List<String> listaMontosMinimos = beanEntrada.getLisMontoMinEsqTasa();
	List<String> listaMontosMaximos = beanEntrada.getLisMontoMaxEsqTasa();
	List<String> listaTasas = beanEntrada.getLisTasaEsqTasa();
	
	ArrayList<NomEsquemaTasaCredBean> listaDetalle = new ArrayList<NomEsquemaTasaCredBean>();
	
	NomEsquemaTasaCredBean iterBean = null;
	int tamanio = 0;
	if(listaTiposEmpleados != null){
		tamanio = listaTiposEmpleados.size();
	}
	
	for(int fila = 0; fila < tamanio; fila++){
		iterBean = new NomEsquemaTasaCredBean();
		
		iterBean.setSucursalID(listaSucursales.get(fila));
		iterBean.setTipoEmpleadoID(listaTiposEmpleados.get(fila));
		iterBean.setPlazoID(listaPlazos.get(fila));
		iterBean.setMinCred(listaMinCreds.get(fila));
		iterBean.setMaxCred(listaMaxCreds.get(fila));
		iterBean.setMontoMin(listaMontosMinimos.get(fila));
		iterBean.setMontoMax(listaMontosMaximos.get(fila));
		iterBean.setTasa(listaTasas.get(fila));
		listaDetalle.add(iterBean);
	}
	
	return listaDetalle;
}

	public NominaCondicionCredDAO getNominaCondicionCredDAO() {
		return nominaCondicionCredDAO;
	}


	public void setNominaCondicionCredDAO(
			NominaCondicionCredDAO nominaCondicionCredDAO) {
		this.nominaCondicionCredDAO = nominaCondicionCredDAO;
	}


	public NomEsquemaTasaCredDAO getNomEsquemaTasaCredDAO() {
		return nomEsquemaTasaCredDAO;
	}


	public void setNomEsquemaTasaCredDAO(NomEsquemaTasaCredDAO nomEsquemaTasaCredDAO) {
		this.nomEsquemaTasaCredDAO = nomEsquemaTasaCredDAO;
	}





}
