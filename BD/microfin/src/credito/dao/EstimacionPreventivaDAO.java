package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import credito.bean.EstimacionPreventivaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class EstimacionPreventivaDAO extends BaseDAO{
	EstimacionPreventivaDAO estimacionPreventivaDAO = null;
	PolizaDAO				polizaDAO				= null;
	
	public EstimacionPreventivaDAO(){
		super();
	}
	
	// metodo para generar el numero de poliza y despues ejecutar el metodo que realiza la estimacion de reserva 
		public MensajeTransaccionBean estimacionPreventiva(final EstimacionPreventivaBean estimacionPreventivaBean) {		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final PolizaBean polizaBean = new PolizaBean();
		
		polizaBean.setConceptoID(EstimacionPreventivaBean.conceptoEstimacionPreventiva);
		polizaBean.setConcepto(EstimacionPreventivaBean.conceptoEstimacionPreventivaDes);
		polizaBean.setFecha(Utileria.convierteFecha(estimacionPreventivaBean.getFechaCorte()));

			transaccionDAO.generaNumeroTransaccion();
			
			int	contador  = 0;
			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());			
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		
						String numeroPoliza = polizaBean.getPolizaID();

						try {
							estimacionPreventivaBean.setPolizaID(numeroPoliza);
							mensajeBean = generaEstimacionPreventiva(estimacionPreventivaBean,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero() != 0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						 catch (Exception e) {
							if(mensajeBean.getNumero() == 0 ){
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al generar el numero de poliza", e);
						}
						return mensajeBean;
					}
				});
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
				return mensaje;
		}
	
					
					
	public MensajeTransaccionBean generaEstimacionPreventiva(final EstimacionPreventivaBean estimacionPreventivaBean, final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) transactionTemplate
				.execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							// Query con el Store Procedure
							String query = "call CIERRERESERVAPRO(?,?,?,?,?,   ?,?,?,?,?);";
							
							Object[] parametros = {
									Utileria.convierteFecha(estimacionPreventivaBean.getFechaCorte()),
									estimacionPreventivaBean.getAplicacionContable(),
									Utileria.convierteEntero(estimacionPreventivaBean.getPolizaID()),
									
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"EstimacionPreventivaDAO.generaEstimacionPreventiva",
									parametrosAuditoriaBean.getSucursal(),
									numeroTransaccion
									};
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CIERRERESERVAPRO(" +Arrays.toString(parametros) + ")");
								List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
								public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
									MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
									mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
									mensaje.setDescripcion(resultSet.getString(2));
									mensaje.setNombreControl(resultSet.getString(3));
									return mensaje;
								}
							});
							return matches.size() > 0 ? (MensajeTransaccionBean) matches
									.get(0) : null;

						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cierre de reserva preventiva", e);
						}
						return mensajeBean;
					}
				});
		return mensaje;
	}
	
	
	
	public EstimacionPreventivaBean consultaFecha(EstimacionPreventivaBean estimacionPreventivaBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call SALDOSCREDITOSCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
								estimacionPreventivaBean.getFechaCorte(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSCREDITOSCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				EstimacionPreventivaBean estimacionPreventivaBean = new EstimacionPreventivaBean();
				estimacionPreventivaBean.setFechaCorte(resultSet.getString(1));
				return estimacionPreventivaBean;
			}
		});
		return matches.size() > 0 ? (EstimacionPreventivaBean) matches.get(0) : null;
	}
	
	//Consulta la Ultima Fecha de Calificacion Y Estimaciones en base a una Fecha Dada
	public EstimacionPreventivaBean consultaFechaEstimacion(EstimacionPreventivaBean estimacionPreventivaBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CALRESCREDITOSCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
								estimacionPreventivaBean.getFechaCorte(),
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALRESCREDITOSCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				EstimacionPreventivaBean estimacionPreventivaBean = new EstimacionPreventivaBean();
				estimacionPreventivaBean.setFechaCorte(resultSet.getString(1));
				return estimacionPreventivaBean;
			}
		});
		return matches.size() > 0 ? (EstimacionPreventivaBean) matches.get(0) : null;
	}
	
	
	
	//Consulta la Ultima Fecha de un credito y sus reservas
	public EstimacionPreventivaBean consultaFechaCred(EstimacionPreventivaBean estimacionPreventivaBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CALRESCREDITOSCON(?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = { 
								Constantes.FECHA_VACIA,
								estimacionPreventivaBean.getCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALRESCREDITOSCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				EstimacionPreventivaBean estimacionPreventivaBean = new EstimacionPreventivaBean();
				estimacionPreventivaBean.setUltimaFecha(resultSet.getString(1));
				estimacionPreventivaBean.setTotalReserva(resultSet.getString(2));
				estimacionPreventivaBean.setSaldoCap(resultSet.getString(3));
				estimacionPreventivaBean.setSaldoInt(resultSet.getString(4));
				return estimacionPreventivaBean;
			}
		});
		return matches.size() > 0 ? (EstimacionPreventivaBean) matches.get(0) : null;
	}

	
	
	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}
	
}
