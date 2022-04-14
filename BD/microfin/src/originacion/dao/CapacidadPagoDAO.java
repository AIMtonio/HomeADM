package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.CapacidadPagoBean;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CapacidadPagoDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;

	public CapacidadPagoDAO(){
		super();
	}



	/*=============================== METODOS ==================================*/

	/* da de alta una estimacion de capacidad de pago para un cliente */
	public MensajeTransaccionBean alta(final CapacidadPagoBean capacidadPagoBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call CAPACIDADPAGOALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(capacidadPagoBean.getClienteID()));
						sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(capacidadPagoBean.getUsuarioID()));
						sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(capacidadPagoBean.getSucursalID()));
						sentenciaStore.setInt("Par_ProducCredito1", Utileria.convierteEntero(capacidadPagoBean.getProducCredito1()));
						sentenciaStore.setInt("Par_ProducCredito2", Utileria.convierteEntero(capacidadPagoBean.getProducCredito2()));
						sentenciaStore.setInt("Par_ProducCredito3", Utileria.convierteEntero(capacidadPagoBean.getProducCredito3()));
						sentenciaStore.setDouble("Par_TasaInteres1", Utileria.convierteDoble(capacidadPagoBean.getTasaInteres1()));
						sentenciaStore.setDouble("Par_TasaInteres2", Utileria.convierteDoble(capacidadPagoBean.getTasaInteres2()));
						sentenciaStore.setDouble("Par_TasaInteres3", Utileria.convierteDoble(capacidadPagoBean.getTasaInteres3()));
						sentenciaStore.setDouble("Par_IngresoMensual", Utileria.convierteDoble(capacidadPagoBean.getIngresoMensual()));
						sentenciaStore.setDouble("Par_GastoMensual", Utileria.convierteDoble(capacidadPagoBean.getGastoMensual()));
						sentenciaStore.setDouble("Par_MontoSolicitado", Utileria.convierteDoble(capacidadPagoBean.getMontoSolicitado()));
						sentenciaStore.setDouble("Par_AbonoPropuesto", Utileria.convierteDoble(capacidadPagoBean.getAbonoPropuesto()));
						sentenciaStore.setString("Par_Plazo", capacidadPagoBean.getPlazo());
						sentenciaStore.setDouble("Par_AbonoEstimado", Utileria.convierteDoble(capacidadPagoBean.getAbonoEstimado()));
						sentenciaStore.setDouble("Par_IngresosGastos", Utileria.convierteDoble(capacidadPagoBean.getIngresosGastos()));
						sentenciaStore.setDouble("Par_Cobertura", Utileria.convierteDoble(capacidadPagoBean.getCobertura()));
						sentenciaStore.setDouble("Par_CobSinPrestamo", Utileria.convierteDoble(capacidadPagoBean.getCobSinPrestamo()));
						sentenciaStore.setDouble("Par_CobConPrestamo", Utileria.convierteDoble(capacidadPagoBean.getCobConPrestamo()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAPACIDADPAGOALT(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta estimación de capacidad de pago", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de alta



	/* Obtiene la ultima estimacion de capacidad de pago del cliente*/
	public CapacidadPagoBean ultimaEstimacion(CapacidadPagoBean bean,  final int tipoConsulta) {
		CapacidadPagoBean capacidaPagoBean= new CapacidadPagoBean();

		try{
			/*Query con el Store Procedure */
			String query = "call CAPACIDADPAGOCON(?,?,?,?,  ?,?,?,?,?);";

			Object[] parametros = { Utileria.convierteEntero(bean.getClienteID()) ,
									tipoConsulta,
									Constantes.ENTERO_CERO,		//	Par_EmpresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO };	//	numTransaccion

			/*Registra el  inf. del log */
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAPACIDADPAGOCON(" + Arrays.toString(parametros) + ")");

			/*E]ecuta el query y setea los valores al bean*/
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
						CapacidadPagoBean bean = new CapacidadPagoBean();

						bean.setClienteID(resultSet.getString("ClienteID"));
						bean.setCobertura(resultSet.getString("Cobertura"));
						bean.setFecha(resultSet.getString("Fecha"));

						return bean;
						}// trows ecexeption
			});// fin de consulta


			capacidaPagoBean= matches.size() > 0 ? (CapacidadPagoBean) matches.get(0) : null;

	/*Maneja la exception y registra el log de error */
}catch(Exception e){
	e.printStackTrace();
	loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de estimación de capacidad de pago", e);
}


/*Retorna un objeto cargado de datos */
return capacidaPagoBean;
}// consulta

	/**
	 * Obtiene la estimacion de la capacidad de pago del cliente
	 * @param bean de CapacidadPagoBean
	 * @return
	 */
	public CapacidadPagoBean calculaEstimacion(final CapacidadPagoBean bean) {

		CapacidadPagoBean mensaje = new CapacidadPagoBean();
		mensaje = (CapacidadPagoBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				CapacidadPagoBean mensajeBean = new CapacidadPagoBean();
				try {
					mensajeBean = (CapacidadPagoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CAPACIDADPAGOPRO("
											+ "?,?,?,?,?,       "
											+ "?,?,?,?,?,       "
											+ "?,?,?,?,?,       "
											+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(bean.getClienteID()));
									sentenciaStore.setInt("Par_Sucursal", Utileria.convierteEntero(bean.getSucursal()));
									sentenciaStore.setDouble("Par_IngresoMensual", Utileria.convierteEntero(bean.getIngresoMensual()));
									sentenciaStore.setDouble("Par_GastoMensual", Utileria.convierteDoble(bean.getGastoMensual()));
									sentenciaStore.setDouble("Par_MontoSolicitado", Utileria.convierteDoble(bean.getMontoSolicitado()));
									sentenciaStore.setInt("Par_ProductoCredito1", Utileria.convierteEntero(bean.getProducCredito1()));
									sentenciaStore.setInt("Par_ProductoCredito2", Utileria.convierteEntero(bean.getProducCredito2()));
									sentenciaStore.setInt("Par_ProductoCredito3", Utileria.convierteEntero(bean.getProducCredito3()));
									sentenciaStore.setString("Par_Plazos", bean.getPlazo());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setInt("Aud_Empresa", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									CapacidadPagoBean mensajeTransaccion = new CapacidadPagoBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										CapacidadPagoBean bean = new CapacidadPagoBean();

										bean.setClienteID(resultadosStore.getString("ClienteID"));
										bean.setPorcentajeCob(resultadosStore.getString("PorcentajeCob"));
										bean.setCoberturaMin(resultadosStore.getString("CoberturaMin"));
										bean.setIngresosGastos(resultadosStore.getString("IngresosGastos"));
										bean.setCobSinPrestamo(resultadosStore.getString("CobSinPrestamo"));
										loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos() + "-" + resultadosStore.getString("TasaInteres1"));
										bean.setTasaInteres1(resultadosStore.getString("TasaInteres1"));
										bean.setTasaInteres2(resultadosStore.getString("TasaInteres2"));
										bean.setTasaInteres3(resultadosStore.getString("TasaInteres3"));
										bean.setNumero(resultadosStore.getInt("NumErr"));
										bean.setDescripcion(resultadosStore.getString("ErrMen"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if (mensajeBean == null) {
						mensajeBean = new CapacidadPagoBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cálculo de estimación de capacidad de pago", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// consulta


	/* Consulta los tipo de productos de credito que apareceran seleccionados por default en la pantalla de Estimacion Capacidad de Pago */
	public List productosCredito(){
		List producto = new ArrayList();
		String pc1 = PropiedadesSAFIBean.propiedadesSAFI.getProperty("ProductoCredito1");
		String pc2 = PropiedadesSAFIBean.propiedadesSAFI.getProperty("ProductoCredito2");
		String pc3 = PropiedadesSAFIBean.propiedadesSAFI.getProperty("ProductoCredito3");

		producto.add(0,Integer.parseInt(pc1));
		producto.add(1,Integer.parseInt(pc2));
		producto.add(2,Integer.parseInt(pc3));

		return producto;
	}



	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}



	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}



}
