package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import tesoreria.bean.AnticipoFacturaBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import nomina.bean.InstitucionNominaBean;

public class InstitucionNominaDAO extends BaseDAO{
	public InstitucionNominaDAO(){
		super();
	}
	/* Alta Institución de Nómina */
	public MensajeTransaccionBean registraInstitucionNomina(int tipoTransaccion,final InstitucionNominaBean institucionNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					institucionNominaBean.setTelContactoRH(institucionNominaBean.getTelContactoRH().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INSTITNOMINAALT(?,?,?,?,?,		?,?,?,?,?,   ?,?,?,?,?,		?,?,?,?,?,"
																		+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_NombreInstit",institucionNominaBean.getNombreInstit());
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(institucionNominaBean.getClienteID()));
									sentenciaStore.setString("Par_ContactoRH",institucionNominaBean.getContactoRH());
									sentenciaStore.setString("Par_ExtTelContacto",institucionNominaBean.getExtTelContacto());
									sentenciaStore.setString("Par_TelContactoRH",institucionNominaBean.getTelContactoRH());


									sentenciaStore.setInt("Par_BancoDeposito",Utileria.convierteEntero(institucionNominaBean.getInstitucionID()));
									sentenciaStore.setString("Par_CuentaDeposito",institucionNominaBean.getNumCtaInstit());
									sentenciaStore.setString("Par_Correo",institucionNominaBean.getCorreo());
									sentenciaStore.setString("Par_ReqVerificacion",institucionNominaBean.getReqVerificacion());
									sentenciaStore.setString("Par_Domicilio",institucionNominaBean.getDomicilio());

									sentenciaStore.setString("Par_EspCta",institucionNominaBean.getEspCtaCon());
									sentenciaStore.setString("Par_NumCta",institucionNominaBean.getNumCtaContable());
									sentenciaStore.setInt("Par_TipoMovID",Utileria.convierteEntero(institucionNominaBean.getTipoMovID()));
									sentenciaStore.setString("Par_AplicaTabla",institucionNominaBean.getAplicaTabla());
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
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de institucion de nomina", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}

	/* Modifica Institución de Nómina*/
	public MensajeTransaccionBean modificarInstitucionNomina(final InstitucionNominaBean institucionNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INSTITNOMINAMOD(?,?,?,?,?,?,?,?,?,?,?,   ?,?,?,  ?,?,?,?,?,?,?,"
											+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(institucionNominaBean.getInstitNominaID()));
									sentenciaStore.setString("Par_NombreInstit",institucionNominaBean.getNombreInstit());
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(institucionNominaBean.getClienteID()));
									sentenciaStore.setString("Par_ContactoRH",institucionNominaBean.getContactoRH());
									sentenciaStore.setString("Par_TelContactoRH",institucionNominaBean.getTelContactoRH());

									sentenciaStore.setString("Par_ExtTelContacto",institucionNominaBean.getExtTelContacto());
									sentenciaStore.setInt("Par_BancoDeposito",Utileria.convierteEntero(institucionNominaBean.getInstitucionID()));
									sentenciaStore.setString("Par_CuentaDeposito",institucionNominaBean.getNumCtaInstit());
									sentenciaStore.setString("Par_Correo",institucionNominaBean.getCorreo());
									sentenciaStore.setString("Par_ReqVerificacion",institucionNominaBean.getReqVerificacion());

									sentenciaStore.setString("Par_Domicilio",institucionNominaBean.getDomicilio());
									sentenciaStore.setString("Par_EspCta",institucionNominaBean.getEspCtaCon());
									sentenciaStore.setString("Par_NumCta",institucionNominaBean.getNumCtaContable());
									sentenciaStore.setInt("Par_TipoMovID",Utileria.convierteEntero(institucionNominaBean.getTipoMovID()));
									sentenciaStore.setString("Par_AplicaTabla",institucionNominaBean.getAplicaTabla());

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
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								    loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
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
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de institucion de nomina", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

			// Baja de Institucion de Nomina
			public MensajeTransaccionBean estatusBajaInstitucion(final InstitucionNominaBean institucionNominaBean, final int tipoActualizacion) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {

							// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call INSTITNOMINAACT (" +
												"?,?,	?,?,?," +
												"?,?,?,?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(institucionNominaBean.getInstitNominaID()));
										sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(institucionNominaBean.getClienteID()));
										sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

										return sentenciaStore;
									}
								},new CallableStatementCallback() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																													DataAccessException {
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
								}
								);

							if(mensajeBean ==  null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cancelacion de factura", e);
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

			// Consulta de Institucion de Nomina
		public InstitucionNominaBean consultaPrincipal(int tipoConsulta, InstitucionNominaBean institucionNominaBean){
			String query = "call INSTITNOMINACON(" +
					"?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(institucionNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(institucionNominaBean.getClienteID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"InstitucionNominaDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					InstitucionNominaBean institNomina = new InstitucionNominaBean();

					institNomina.setInstitNominaID(resultSet.getString("InstitNominaID"));
					institNomina.setNombreInstit(resultSet.getString("NombreInstit"));
					institNomina.setClienteID(resultSet.getString("ClienteID"));
					institNomina.setContactoRH(resultSet.getString("ContactoRH"));
					institNomina.setTelContactoRH(resultSet.getString("TelContactoRH"));
					institNomina.setExtTelContacto(resultSet.getString("ExtTelContacto"));
					institNomina.setInstitucionID(resultSet.getString("BancoDeposito"));
					institNomina.setCuentaDeposito(resultSet.getString("CuentaDeposito"));
					institNomina.setEstatus(resultSet.getString("Estatus"));
					institNomina.setCorreo(resultSet.getString("Correo"));
					institNomina.setDomicilio(resultSet.getString("Domicilio"));
					institNomina.setReqVerificacion(resultSet.getString("ReqVerificacion"));

					institNomina.setEspCtaCon(resultSet.getString("EspCtaCon"));
					institNomina.setNumCtaContable(resultSet.getString("NumCuentaCon"));
					institNomina.setTipoMovID(resultSet.getString("TipoMovID"));
					institNomina.setAplicaTabla(resultSet.getString("AplicaTabla"));

					return institNomina;
			}
		});

		return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;
	}



  // Lista de Institucion de Nomina
  public List listaInstitucion(int tipoLista,InstitucionNominaBean institucionBean ) {
	  List listaInstitucion=null;
		try{
	String query = "call INSTITNOMINALIS(?,?,?,  ?,?,?,?,?,?,?);";
	Object[] parametros = {
			Utileria.convierteEntero(institucionBean.getClienteID()),
			institucionBean.getInstitNominaID(),
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"InstitucionNominaDAO.listaInstitucion",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum)
				throws SQLException {

			InstitucionNominaBean institucionNominaBean= new InstitucionNominaBean();
			institucionNominaBean.setInstitNominaID(resultSet.getString("InstitNominaID"));
			institucionNominaBean.setNombreInstit(resultSet.getString("NombreInstit"));

			return institucionNominaBean;

		}
	});
	listaInstitucion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de institucion de nomina", e);
		}
		return listaInstitucion;
	}

  public InstitucionNominaBean consultaBancoCuenta(int tipoConsulta, InstitucionNominaBean institucionBean){
		String query = "call INSTITNOMINACON(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionBean.getInstitNominaID()),
				Utileria.convierteEntero(institucionBean.getClienteID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InstitucionNominaDAO.consultaBancoCuenta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InstitucionNominaBean institNom = new InstitucionNominaBean();

				institNom.setInstitucionID(resultSet.getString("BancoDeposito"));
				institNom.setNombreBanco(resultSet.getString("Nombre"));
				institNom.setCuentaDeposito(resultSet.getString("CuentaDeposito"));

				return institNom;
			}
		 });

		return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;
	}

  // CONSULTA EL NUMERO DE EMPLEADO
  public InstitucionNominaBean consultaNumeroEmpleado(int tipoConsulta, InstitucionNominaBean institucionBean){
		String query = "call INSTITNOMINACON(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionBean.getInstitNominaID()),
				Utileria.convierteEntero(institucionBean.getClienteID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InstitucionNominaDAO.consultaBancoCuenta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InstitucionNominaBean institNom = new InstitucionNominaBean();

				institNom.setInstitucionID(resultSet.getString("InstitNominaID"));
				institNom.setNombreInstit(resultSet.getString("NombreInstit"));
				institNom.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
				institNom.setNoEmpleado(resultSet.getString("NoEmpleado"));

				return institNom;
			}
		 });

		return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;
	}

	  /*INICIO Lista que muestra las institicuines segun la bitacora de pagos de domiciliacion*/
	  public List listaInstitBitacDomiciPagos(int tipoLista,InstitucionNominaBean institucionBean ) {
		  List listaInstitucion=null;
			try{
		String query = "call INSTITNOMINALIS(?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionBean.getClienteID()),
				institucionBean.getInstitNominaID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"InstitucionNominaDAO.listaInstitBitacDomiciPagos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				InstitucionNominaBean institucionNominaBean= new InstitucionNominaBean();
				institucionNominaBean.setFolioID(resultSet.getString("FolioID"));
				institucionNominaBean.setNombreInstit(resultSet.getString("NombreInstit"));

				return institucionNominaBean;

			}
		});
		listaInstitucion= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista Instituciones por BitacoraDomiciPagos", e);
			}
			return listaInstitucion;
		}

	//CONSULTA PARA SABER SI SE APLICA TABLA REAL O NO
  public InstitucionNominaBean consultaAplicaTabla(int tipoConsulta, InstitucionNominaBean institucionBean){
		String query = "call PARAMGENERALESCON(" +
				"?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InstitucionNominaDAO.consultaAplicaTabla",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMGENERALESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InstitucionNominaBean institNom = new InstitucionNominaBean();
				institNom.setAplicaTabla(resultSet.getString("ValorParametro"));

				return institNom;
			}
		 });

		return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;
	}

  /**
   * Metodo para listar todas las empresas de nomina para mostrarlo en un combo
   * @param tipoLista
   * @return
   */
  public List listarCompaniaTodos(int tipoLista){
	  List lista =null;
	  try{
		  String query = "call INSTITNOMINALIS(?,?,?,?,?, ?,?,?,?,?);";
		  Object[] parametros = {
				  Constantes.ENTERO_CERO,
				  Constantes.ENTERO_CERO,
				  tipoLista,

				  parametrosAuditoriaBean.getEmpresaID(),
				  parametrosAuditoriaBean.getUsuario(),
				  parametrosAuditoriaBean.getFecha(),
				  parametrosAuditoriaBean.getDireccionIP(),
				  "InstitucionNominaDAO.listaInstitBitacDomiciPagos",
				  parametrosAuditoriaBean.getSucursal(),
				  Constantes.ENTERO_CERO
		  };

		  loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINALIS(" + Arrays.toString(parametros) +")");
		  List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			  public Object mapRow(ResultSet resultSet, int rowNum)	throws SQLException {
				  InstitucionNominaBean modeloResult = new InstitucionNominaBean();
				  modeloResult.setInstitucionID(resultSet.getString("InstitNominaID"));
				  modeloResult.setNombreInstit(resultSet.getString("NombreInstit"));

				  return modeloResult;
			  }
		  });

		  lista = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista Instituciones por BitacoraDomiciPagos", e);
		}
		return lista;
	}

}
