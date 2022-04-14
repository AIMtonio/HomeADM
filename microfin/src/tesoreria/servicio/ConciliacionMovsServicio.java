package tesoreria.servicio;

import java.util.ArrayList;
import java.util.List;

import tesoreria.bean.TesoMovsConciliaBean;
import tesoreria.dao.MovimientosGridDAO;
import tesoreria.dao.TesoMovsConciliaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class ConciliacionMovsServicio extends BaseServicio {
		
	MovimientosGridDAO movimientosGridDAO = null;
	TesoMovsConciliaDAO TesoMovsConciliaDAO = null;
	
	public static interface Enum_Tra_Conciliacion {
		int alta				= 1;
		int modifica			= 2;
		int baja 				= 3;
		int cierraConciliacion 	= 4;
	}
	
	public static interface Enum_Con_Conciliacion {
		int principal	= 1;
		int foranea 	= 2;
	}

	public static interface Enum_Lis_Conciliacion {
		int principal 	= 1;
		int foranea 	= 2;
	}
	public static interface Enum_Act_Conciliacion {
		int actSaldo 	= 1;		
	}
	
	public static interface Enum_Lista_Conciliaciones {
		int listaCierreConciliacion = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(TesoMovsConciliaBean tesomovs, int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		switch(tipoTransaccion){
			case Enum_Tra_Conciliacion.alta:
					mensaje=consultaConciliados(tesomovs,tipoTransaccion);
				break;
			case Enum_Tra_Conciliacion.cierraConciliacion:
					// Se genera la lista con las conciliaciones a cerrar.
					ArrayList listaDetalleGrid = (ArrayList) detalleGrid(tesomovs);
					mensaje = TesoMovsConciliaDAO.cierreMovs( tesomovs, listaDetalleGrid );
				break;
		}
		
		return mensaje;
	}
    
	public List lista(int tipoLista, TesoMovsConciliaBean tesoMovsConcilia){
		List tesoMovsConciliaBean = null;
		switch (tipoLista) {
			case Enum_Lista_Conciliaciones.listaCierreConciliacion:
				tesoMovsConciliaBean = TesoMovsConciliaDAO.listaConsultaMovs( tesoMovsConcilia, tipoLista );
				break;
		}
		return tesoMovsConciliaBean;
	}
	
	private List detalleGrid(TesoMovsConciliaBean tesoMovsConciliaBean){
		// Separa las listas del grid en beans individuales
		List<String> listaPeriodos	= tesoMovsConciliaBean.getListaConciliaciones();
		
		ArrayList listaDetalle = new ArrayList();
		
		TesoMovsConciliaBean iterTesoMovsConciliaBean  = null; 
		// Se valida que la lista no sea null
		int tamanio = 0;
		if(listaPeriodos != null){
			tamanio = listaPeriodos.size();
		}
		
		// Se insertan los valores del Bean en el Array
		for( int fila = 0; fila < tamanio; fila++ ){
			iterTesoMovsConciliaBean = new TesoMovsConciliaBean();
			
			// Se valida que solo se agarren las conciliaciones internas e ignore las conciliaciones externas.
			if ( !listaPeriodos.get( fila ).toString().equals( "0" ) ) {

				iterTesoMovsConciliaBean.setNumeroMov( listaPeriodos.get( fila ) );
				listaDetalle.add( iterTesoMovsConciliaBean );
				
			}
		}
		
		return listaDetalle;
	}
	
	public MensajeTransaccionBean consultaConciliados(TesoMovsConciliaBean tesomovs, int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String cadena = "";
		String[] cadenaSplit;

		if(tesomovs.getListaConciliado()!=null){
			List<String> listaConciliados = tesomovs.getListaConciliado();
			if(!listaConciliados.isEmpty()){
				for(int i=0; i<listaConciliados.size(); i++){
					
					cadena = listaConciliados.get(i);
					cadenaSplit = cadena.split(",");
					int folioMovimento = Integer.parseInt(cadenaSplit[0]);
					int folioCargaID = Integer.parseInt(cadenaSplit[1]);
					if(folioCargaID>0){	
						String tipoMovimiento = cadenaSplit[2];
						
						if(folioMovimento!=0 || folioCargaID!=0 ){	
							mensaje = movimientosGridDAO.alta(tipoMovimiento,folioMovimento,folioCargaID );
						}
					}else{
						mensaje.setNumero(9);
						mensaje.setDescripcion("Asegurese de haber indicado al movimiento externo el n&uacute;mero de conciliaci&oacute;n correctamente.");
						mensaje.setConsecutivoInt("");
						mensaje.setConsecutivoInt("");
					}
				}
			}else{
				mensaje.setNumero(9);
				mensaje.setDescripcion("No hay datos que conciliar");
				mensaje.setConsecutivoInt("");
				mensaje.setConsecutivoInt("");
			}
		}else{
			mensaje.setNumero(9);
			mensaje.setDescripcion("No hay datos que conciliar");
			mensaje.setConsecutivoInt("");
			mensaje.setConsecutivoInt("");
		}
		return mensaje;
	}
	
	public void setMovimientosGridDAO(MovimientosGridDAO movimientosGridDAO) {
		this.movimientosGridDAO = movimientosGridDAO;
	}

	public MovimientosGridDAO getMovimientosGridDAO() {
		return movimientosGridDAO;
	}

	public TesoMovsConciliaDAO getTesoMovsConciliaDAO() {
		return TesoMovsConciliaDAO;
	}

	public void setTesoMovsConciliaDAO(TesoMovsConciliaDAO tesoMovsConciliaDAO) {
		TesoMovsConciliaDAO = tesoMovsConciliaDAO;
	}

	

}
