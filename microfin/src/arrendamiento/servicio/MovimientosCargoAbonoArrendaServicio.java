package arrendamiento.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import arrendamiento.bean.CargoAbonoArrendaBean;
import arrendamiento.dao.MovimientosCargoAbonoArrendaDAO;

public class MovimientosCargoAbonoArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	MovimientosCargoAbonoArrendaDAO movimientosCargoAbonoArrendaDAO = null;	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	public static interface Enum_Tra_MovsCargoAbono {
		int altaMovimientosCA=1;
	}
	
	//---------- Lista de Movimientos de cargo y abono------------------------------------
	public static interface Enum_Lis_MovsCargoAbono {
		int principal = 1;
	}
	//---------- Lista de Tipos de Movimientos de cargo y abono------------------------------------
	public static interface Enum_Lis_TipMovsCargoAbono {
		int listaComboPrincipal = 1;
	}
	
	public MovimientosCargoAbonoArrendaServicio() {
		super();
	}	
		
	/**
	 * Metodo de lista para Movimientos de Cargo y Abono de Arrendamiento
	 * @param tipoLista
	 * @param cargoAbonoArrendaBean
	 * @return
	 */
	public List lista(int tipoLista, CargoAbonoArrendaBean cargoAbonoArrendaBean){		
		List listaMovimientos = null;
		switch (tipoLista) {
			case Enum_Lis_MovsCargoAbono.principal:		
				listaMovimientos = movimientosCargoAbonoArrendaDAO.listaMovsCargoAbono(cargoAbonoArrendaBean, tipoLista);	
				break;
		}
		return listaMovimientos;
	}
	
	public List listaCombo(int tipoLista){		
		List listaTipMovimientos = null;
		switch (tipoLista) {
			case Enum_Lis_TipMovsCargoAbono.listaComboPrincipal:		
				listaTipMovimientos = movimientosCargoAbonoArrendaDAO.listaTipMovsCargoAbono(tipoLista);
				break;
		}
		return listaTipMovimientos;
	}
	
	/**
	 * Graba transaccion de movimientos de cargo y abonos de arrendamiento
	 * @param tipoTransaccion
	 * @param cargoAbonoArrendaBean
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccionMovsCA(int tipoTransaccion, CargoAbonoArrendaBean cargoAbonoArrendaBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_MovsCargoAbono.altaMovimientosCA:
				ArrayList listaDetalleGrid = (ArrayList) detalleGrid(cargoAbonoArrendaBean);
				mensaje = movimientosCargoAbonoArrendaDAO.grabaMovimientosCargaAbono(listaDetalleGrid);
				break;
		}
		return mensaje;
	}
	
	private List detalleGrid(CargoAbonoArrendaBean cargoAbonoArrendaBean){
		// Separa las listas del grid en beans individuales	
		List<String> listaArrendaID = cargoAbonoArrendaBean.getArrendaIDCA();
		List<String> listaAmortis = cargoAbonoArrendaBean.getArrendaAmortiIDCA();
		List<String> listaTiposCon = cargoAbonoArrendaBean.getTipoConceptoCA();
		List<String> listaDescripcion = cargoAbonoArrendaBean.getDescriConceptoCA();		
		List<String> listaUsuarios = cargoAbonoArrendaBean.getUsuarioMovimientoCA();
		List<String> listaMonto = cargoAbonoArrendaBean.getMontoConceptoCA();
		List<String> listaNaturaleza = cargoAbonoArrendaBean.getNaturalezaCA();
		
		ArrayList listaDetalle = new ArrayList();
		CargoAbonoArrendaBean iterCargoAbonoArrendaBean  = null; 
		int tamanio = 0;
		
		if(listaArrendaID != null){
			tamanio = listaArrendaID.size();
		}
		for(int i = 0; i < tamanio; i++){
			iterCargoAbonoArrendaBean = new CargoAbonoArrendaBean();
			iterCargoAbonoArrendaBean.setArrendaID(listaArrendaID.get(i));
			iterCargoAbonoArrendaBean.setArrendaAmortiID(listaAmortis.get(i));
			iterCargoAbonoArrendaBean.setTipoConcepto(listaTiposCon.get(i));
			
			iterCargoAbonoArrendaBean.setDescriConcepto(listaDescripcion.get(i));
			iterCargoAbonoArrendaBean.setUsuarioMovimiento(listaUsuarios.get(i));
			iterCargoAbonoArrendaBean.setMontoConcepto(listaMonto.get(i));
			iterCargoAbonoArrendaBean.setNaturaleza(listaNaturaleza.get(i));
			
			listaDetalle.add(iterCargoAbonoArrendaBean);
		}
		return listaDetalle;
	}
	//------------------ Geters y Seters ------------------------------------------------------	
	public MovimientosCargoAbonoArrendaDAO getMovimientosCargoAbonoArrendaDAO() {
		return movimientosCargoAbonoArrendaDAO;
	}

	public void setMovimientosCargoAbonoArrendaDAO(
			MovimientosCargoAbonoArrendaDAO movimientosCargoAbonoArrendaDAO) {
		this.movimientosCargoAbonoArrendaDAO = movimientosCargoAbonoArrendaDAO;
	}			
}


