package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.LineasCreditoBean;

import tesoreria.bean.RequisicionGastosBean;
import tesoreria.bean.RequisicionTipoGastoListaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
public class RequisicionGastosDAO extends BaseDAO {
	
	public RequisicionGastosDAO(){
		super();
	}
	
	//--------------------- Transacciones -----------------------------------------------------
	
	/* Alta de la Requisicion*/
	public MensajeTransaccionBean altaRequisicion(final RequisicionGastosBean requisicionGastosBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						//Query con el Store Procedure
						String query = "call TESOREQGASALT(?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";

						Object[] parametros = {	
												
							requisicionGastosBean.getSucursalID(),
							requisicionGastosBean.getUsuarioID(),
							requisicionGastosBean.getTipoGastoID(),
							requisicionGastosBean.getDescripcionRG(),
							requisicionGastosBean.getMonto(),
							requisicionGastosBean.getTipoPago(),
							requisicionGastosBean.getNumCtaInstit(), 
							requisicionGastosBean.getCentroCostoID(),
							"2012-01-01",
							requisicionGastosBean.getFechaSolicitada(),
							requisicionGastosBean.getCuentaAhoID(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RequisicionGastoDAO.altaRequisicion",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOREQGASALT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));
								//mensaje.setConsecutivoString(resultSet.getString(4));
								return mensaje;
							}
						});
				
						return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				 	}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de requisicion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}
	
	public MensajeTransaccionBean modificaRequisicion(final RequisicionGastosBean requisicionGastosBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call TESOREQGASMOD(?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							requisicionGastosBean.getRequisicionID(),
							requisicionGastosBean.getTipoGastoID(),
							requisicionGastosBean.getDescripcionRG(),
							requisicionGastosBean.getMonto(),
							requisicionGastosBean.getTipoPago(),
							requisicionGastosBean.getNumCtaInstit(),
							requisicionGastosBean.getCentroCostoID(),
							requisicionGastosBean.getFechaSolicitada(),
							requisicionGastosBean.getCuentaAhoID(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"ProductosCreditoDAO.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOREQGASMOD(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de requisicion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	
	public RequisicionGastosBean consultaPrincipal(final RequisicionGastosBean requisicionGastosBean, int tipoConsulta){
		//Query con el Store Procedure
		String query = "call TESOREQGASCON(?,? ,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { requisicionGastosBean.getRequisicionID(),
								Constantes.ENTERO_CERO,
								Constantes.STRING_CERO,
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ProductosCreditoDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOREQGASCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				    
				
				
				RequisicionGastosBean requisicionGastosBean = new RequisicionGastosBean();

				requisicionGastosBean.setRequisicionID(resultSet.getString(1));
				requisicionGastosBean.setSucursalID(resultSet.getString(2));
				requisicionGastosBean.setUsuarioID(resultSet.getString(3));
				requisicionGastosBean.setTipoGastoID(resultSet.getString(4));				
				requisicionGastosBean.setDescripcionRG(resultSet.getString(5));
				requisicionGastosBean.setMonto(String.valueOf(resultSet.getFloat(6)));
				requisicionGastosBean.setTipoPago(resultSet.getString(7));
				requisicionGastosBean.setNumCtaInstit(resultSet.getString(8));
				requisicionGastosBean.setCentroCostoID(resultSet.getString(9));
				requisicionGastosBean.setFechaSolicitada(resultSet.getString(10));				
				requisicionGastosBean.setCuentaAhoID(resultSet.getString(11));
				requisicionGastosBean.setStatus(resultSet.getString(12));
				
	
				return requisicionGastosBean;
			}
		});
		return matches.size() > 0 ? (RequisicionGastosBean) matches.get(0) : null;
	
	}
	
	// Consulta presupuesto por factura
	public RequisicionGastosBean consultaPorFactura(final RequisicionGastosBean requisicionGastosBean, int tipoConsulta){
		//Query con el Store Procedure
		String query = "call TESOREQGASCON(?,? ,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { Constantes.ENTERO_CERO,
								requisicionGastosBean.getRequisicionID(), // envia el numero de factura
								Utileria.convierteEntero(requisicionGastosBean.getTipoGastoID()), // envia el proveedor
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								requisicionGastosBean.getSucursalID(),
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOREQGASCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				    
				RequisicionGastosBean requisicionGastosBean = new RequisicionGastosBean();
				requisicionGastosBean.setRequisicionID(resultSet.getString(1)); // almacena los folios
				requisicionGastosBean.setMonto(String.valueOf(resultSet.getDouble(2))); // almacena el monto
				requisicionGastosBean.setTipoPago(String.valueOf(resultSet.getString(3))); // almacena el monto disponible
			
				return requisicionGastosBean;
			}
		});
		return matches.size() > 0 ? (RequisicionGastosBean) matches.get(0) : null;
	
	}
	
	// Consulta presupuesto de tipos de gastos por factura
		public RequisicionGastosBean consultaPresupGtosFactura(final RequisicionGastosBean requisicionGastosBean, int tipoConsulta){
			//Query con el Store Procedure
			
			String query = "call TESOREQGASCON(?,? ,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { Constantes.ENTERO_CERO,
									requisicionGastosBean.getRequisicionID(), // envia el numero de factura
									Utileria.convierteEntero(requisicionGastosBean.getTipoGastoID()), // envia el proveedor
									tipoConsulta,
									
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									requisicionGastosBean.getSucursalID(),
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOREQGASCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					    
					
					RequisicionGastosBean requisicionGastosBean = new RequisicionGastosBean();
			
					requisicionGastosBean.setRequisicionID(resultSet.getString(1)); // almacena el mensaje de presupuesto por gasto
					requisicionGastosBean.setMonto(String.valueOf(resultSet.getDouble(2))); // almacena el monto fuera de presupuesto
					return requisicionGastosBean;
				}
			});
			return matches.size() > 0 ? (RequisicionGastosBean) matches.get(0) : null;
		
		}
	
	
	
	public RequisicionTipoGastoListaBean consultaTipoGas(final RequisicionTipoGastoListaBean requisicionTipoGastoListaBean, int tipoConsulta){
		//Query con el Store Procedure
		String query = "call TESOCATTIPGASCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { requisicionTipoGastoListaBean.getTipoGastoID(),
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ProductosCreditoDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOCATTIPGASCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RequisicionTipoGastoListaBean requisicionTipoGastoListaBean = new RequisicionTipoGastoListaBean();
				requisicionTipoGastoListaBean.setTipoGastoID(resultSet.getString(1));
				requisicionTipoGastoListaBean.setDescripcionTG(resultSet.getString(2));
				return requisicionTipoGastoListaBean;
			}
		});
		return matches.size() > 0 ? (RequisicionTipoGastoListaBean) matches.get(0) : null;
	}

	
	public List listaPrincipal(RequisicionGastosBean requisicionGastosBean, int tipoLista){

		String query = "call TESOREQGASLIS(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {
					requisicionGastosBean.getDescripcionRG(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RequisicionGastosDAO.listaTipoGasto",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOREQGASLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RequisicionGastosBean requisicionGastos = new RequisicionGastosBean();
				requisicionGastos.setRequisicionID(resultSet.getString(1)); 
				requisicionGastos.setDescripcionRG(resultSet.getString(2));
				return requisicionGastos;
			}
		});
		return matches;
	}
	
	public List listaTipoGasto(RequisicionTipoGastoListaBean requisicionTipoGastoListaBean, int tipoLista){

		String query = "call TESOCATTIPGASLIS(?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {
					requisicionTipoGastoListaBean.getDescripcionTG(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RequisicionGastosDAO.listaTipoGasto",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOCATTIPGASLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RequisicionTipoGastoListaBean requisicionTipoGastoLista = new RequisicionTipoGastoListaBean();
				requisicionTipoGastoLista.setTipoGastoID(resultSet.getString(1)); 
				requisicionTipoGastoLista.setDescripcionTG(resultSet.getString(2));
				return requisicionTipoGastoLista;
			}
		});
		return matches;
	}

}
