package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


import nomina.bean.PagoNominaBean;

public class PagoNominaDAO extends BaseDAO{
	public PagoNominaDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* Alta de Pagos de Nomina en PAGOSNOMINA */
	public MensajeTransaccionBean altaPagosNomina(final PagoNominaBean pagoNominaBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL BEPAGOSNOMINALT(?,?,?,?,?,?,?,	?,?,?,  ?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(pagoNominaBean.getFolioCargaID()));
							sentenciaStore.setInt("Par_FolioCargaIDBE",Utileria.convierteEntero(pagoNominaBean.getFolioCargaIDBE()));
							sentenciaStore.setInt("Par_EmpresaNominaID",Utileria.convierteEntero(pagoNominaBean.getInstitNominaID()));
							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(pagoNominaBean.getCreditoID()));
							sentenciaStore.setString("Par_ClienteID",pagoNominaBean.getClienteID());
							sentenciaStore.setDouble("Par_MontoPagos",Utileria.convierteDoble(pagoNominaBean.getMontoPagos()));
							sentenciaStore.registerOutParameter("Var_Folio", Types.INTEGER);
							//Parametros de OutPut
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					}
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de pagos de nomina", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Lista para el grid de Aplicacion de Pagos credito Nomina
	public List<PagoNominaBean> listaPagosGrid(PagoNominaBean pagoNominaBean, int tipoLista) {
		List<PagoNominaBean> listaPagoNominaBean = null;
		try{
			String query = "call BEPAGOSNOMINALIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				pagoNominaBean.getFolioCargaID(),
				pagoNominaBean.getInstitNominaID(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PagosNominaDAO.listaPagosGrid",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BEPAGOSNOMINALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PagoNominaBean listaPagos = new PagoNominaBean();
					listaPagos.setConsecutivoID(resultSet.getString("ConsecutivoID"));
					listaPagos.setEsSeleccionado(resultSet.getString("EsSeleccionado"));
					listaPagos.setFolioNominaID(resultSet.getString("FolioNominaID"));
					listaPagos.setFechaCarga(resultSet.getString("FechaCarga"));
					listaPagos.setMontoPagos(resultSet.getString("MontoPagos"));
					listaPagos.setClienteID(resultSet.getString("ClienteID"));
					listaPagos.setCreditoID(resultSet.getString("CreditoID"));

					return listaPagos;
				}
			});

			listaPagoNominaBean= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Aplicacion de Pagos credito Nomina", e);
		}
		return listaPagoNominaBean;
	}

   // metodo para aplicar los pagos de credito nomina
   public MensajeTransaccionBean realizarPagosCredito(final PagoNominaBean pagoNominaBean, final long numeroTransaccion, final long polizaID){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL PAGOCREDITOBEPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_FolioNominaID",Utileria.convierteEntero(pagoNominaBean.getFolioNominaID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(pagoNominaBean.getClienteID()));
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(pagoNominaBean.getCreditoID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(pagoNominaBean.getMontoPagos()));
							sentenciaStore.setString("Par_FechaAplica", pagoNominaBean.getFechaAplica());
							sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(pagoNominaBean.getInstitNominaID()));
							sentenciaStore.setInt("Par_FolioCargaIDTeso", Utileria.convierteEntero(pagoNominaBean.getDepositoBancos()));
							sentenciaStore.setString("Par_BorraDatos", pagoNominaBean.getBorraDatos());

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);
							sentenciaStore.setLong("Par_Poliza", polizaID);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							 }else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							 }
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
						mensajeBean.setNombreControl(Constantes.STRING_VACIO);
						mensajeBean.setConsecutivoString(Constantes.STRING_CERO);

						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
					}else if(mensajeBean.getNumero()!=0){
						mensajeBean.setNumero(mensajeBean.getNumero());
						mensajeBean.setDescripcion(mensajeBean.getDescripcion());
						mensajeBean.setNombreControl(mensajeBean.getNombreControl());
						mensajeBean.setConsecutivoString(mensajeBean.getConsecutivoString());
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion(e.getMessage());
					}else{
						mensajeBean.setDescripcion(mensajeBean.getDescripcion());
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la aplicación de los pagos de credito nomina DAO", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Metodo para cancelar los pagos de credito nomina
	public MensajeTransaccionBean cancelarPagosCredito(final PagoNominaBean pagoNominaBean, final long numTransaccion, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute( new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BEPAGOSNOMINACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_FolioNominaID", Utileria.convierteEntero(pagoNominaBean.getFolioNominaID()));
							sentenciaStore.setInt("Par_FolioCargaID", Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Par_CreditoID", Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Par_ClienteID", Constantes.ENTERO_CERO);
							sentenciaStore.setDouble("Par_MontoPagos", Constantes.ENTERO_CERO);

							sentenciaStore.setString("Par_Estatus", Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_MotivoCancela", pagoNominaBean.getMotivoCancela());
							sentenciaStore.setInt("Par_TipoAct", tipoActualizacion);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							}else{
								 mensajeTransaccion.setNumero(999);
								 mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							}

							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
						mensajeBean.setNombreControl(Constantes.STRING_VACIO);
						mensajeBean.setConsecutivoString(Constantes.STRING_CERO);

						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
					}else if(mensajeBean.getNumero()!=0){
						mensajeBean.setNumero(mensajeBean.getNumero());
						mensajeBean.setDescripcion(mensajeBean.getDescripcion());
						mensajeBean.setNombreControl(mensajeBean.getNombreControl());
						mensajeBean.setConsecutivoString(mensajeBean.getConsecutivoString());
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion(e.getMessage());
					}else{
						mensajeBean.setDescripcion(mensajeBean.getDescripcion());
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la cancelación de los pagos de credito nomina DAO", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Consulta de Correo Electronico de Institucion de Nomina
	public PagoNominaBean consultaCorreoWS(PagoNominaBean pagosNominaBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call INSTITNOMINACON(?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
			Utileria.convierteEntero(pagosNominaBean.getInstitNominaID()),
			Constantes.ENTERO_CERO,
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"PagosNominaDAO.consultaCorreoWS",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				PagoNominaBean correoInstitucion = new PagoNominaBean();
				correoInstitucion.setCorreoElectronico(resultSet.getString("Correo"));

				return correoInstitucion;
			}
		});
		return matches.size() > 0 ? (PagoNominaBean) matches.get(0) : null;
	}

	//Lista combo de los movimientos No concilados en Tesoreria
	public List listaMovsTeso(PagoNominaBean pagoNominaBean, int tipoConsulta){
		String query = "call TESOMOVCONCILIALIS(?,?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
			Utileria.convierteEntero(pagoNominaBean.getInstitucionID()),
			pagoNominaBean.getNumCuenta(),
			Utileria.convierteEntero(pagoNominaBean.getInstitNominaID()),
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"PagoNominaDAO.listaComboMovsTeso",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOMOVCONCILIALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PagoNominaBean pagoBean = new PagoNominaBean();

				pagoBean.setDepositoBancos(resultSet.getString("Descripcion"));
				pagoBean.setFolioCargaTeso(resultSet.getString("FolioCargaID"));

				return pagoBean;
			}
		});
		return matches;
	}

	// 	Reporte Pagos Aplicados de Credito en Excel
	public List<PagoNominaBean> consultaPagosAplicadosExcel(final PagoNominaBean pagoNominaBean, final int tipoLista){
		List<PagoNominaBean> listaPagoNominaBean = null;
		//Query con el Store Procedure
		try{
			String query = "call PAGOCREDITOWSREP(?,?,?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(pagoNominaBean.getInstitNominaID()),
				Utileria.convierteEntero(pagoNominaBean.getClienteID()),
				pagoNominaBean.getFechaInicio(),
				pagoNominaBean.getFechaFin(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PagoNominaDAO.consultaPagosAplicadosExcel",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOCREDITOWSREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PagoNominaBean pagoNominaBean = new PagoNominaBean();

					pagoNominaBean.setClienteID(resultSet.getString("Cliente"));
					pagoNominaBean.setCreditoID(resultSet.getString("Credito"));
					pagoNominaBean.setCuentaAhoID(resultSet.getString("Cuenta"));
					pagoNominaBean.setFechaPago(resultSet.getString("FechaPago"));
					pagoNominaBean.setMontoPagar(resultSet.getString("MontoPago"));
					pagoNominaBean.setMontoAplicado(resultSet.getString("MontoAplicado"));
					pagoNominaBean.setMontoNoAplicado(resultSet.getString("MontoNoAplicado"));
					pagoNominaBean.setMontoRecibido(resultSet.getString("TotalRecibido"));
					pagoNominaBean.setProducCreditoID(resultSet.getString("ProductoCredito"));
					pagoNominaBean.setHora(resultSet.getString("HoraEmision"));
					pagoNominaBean.setInstitNominaID(resultSet.getString("InstitNominaID"));
					pagoNominaBean.setConvenio(resultSet.getString("ConvenioNominaID"));
					pagoNominaBean.setMotivoCancela(resultSet.getString("MotivoCancelacion"));
					pagoNominaBean.setEstatus(resultSet.getString("Estatus"));
					pagoNominaBean.setFolioCargaID(resultSet.getString("FolioCargaID"));

					return pagoNominaBean;
				}
			});
			listaPagoNominaBean = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el reporte Excel: ", exception);
			listaPagoNominaBean = null;
		}

		return listaPagoNominaBean;
	}

	// Actualizacion de Encabezado de Bitacora de Pagos Aplicados Creditos Nomina
	public MensajeTransaccionBean verificaPoliza(final PagoNominaBean pagoNominaBean, final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(	new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL BEPAGOSNOMINVAL(?,"
															  + "?,?,?,"
															  + "?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteEntero(pagoNominaBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							}

							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
						mensajeBean.setNombreControl(Constantes.STRING_VACIO);
						mensajeBean.setConsecutivoString(Constantes.STRING_CERO);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
					} else if(mensajeBean.getNumero()!=0){
						mensajeBean.setNumero(mensajeBean.getNumero());
						mensajeBean.setDescripcion(mensajeBean.getDescripcion());
						mensajeBean.setNombreControl(mensajeBean.getNombreControl());
						mensajeBean.setConsecutivoString(mensajeBean.getConsecutivoString());
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion(e.getMessage());
					}else{
						mensajeBean.setDescripcion(mensajeBean.getDescripcion());
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de encabezado de la bitacora de Pagos Aplicados de Creditos de Nomina DAO", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

}
