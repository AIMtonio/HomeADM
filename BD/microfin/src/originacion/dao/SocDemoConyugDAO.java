 package originacion.dao;
 import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

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





import originacion.bean.SocDemConyugBean;



public class SocDemoConyugDAO extends BaseDAO{
	public int mensajeExito=0;

	public SocDemoConyugDAO() {
		super();
	}

 	//Graba Limite Quitas
	public MensajeTransaccionBean grabaDatosSocioDemo(final SocDemConyugBean socDemConyugBean){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ArrayList listaDetalleGrid = null ;
				String [] arregloProductos = null;

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = altaHisDatosConyugue(socDemConyugBean );//ALTA HISTORIAL SOCIODEMOGRAFICOS
					if( mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Cliente: " + mensajeBean.getDescripcion());
							mensajeBean.setDescripcion("No es posible realizar la operación, la persona hizo coincidencia con la Listas de Personas Bloqueadas");
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					if( mensajeBean.getNumero()==0){
						mensajeBean = altaDatosConyugue(socDemConyugBean, parametrosAuditoriaBean.getNumeroTransaccion());// ALTA SOCIODEMOGRAAFICOS

						if( mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Cliente: " + mensajeBean.getDescripcion());
								mensajeBean.setDescripcion("No es posible realizar la operación, la Persona hizo coincidencia con la Listas de Personas Bloqueadas");
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}


				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"erroral grabar datos sociodemografico", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensajeResultado;
	}

	// metodo de alta de datos dependientes economicos



	// metodo de alta de datos  sociodemograficos
	public MensajeTransaccionBean altaDatosConyugue (final SocDemConyugBean socDemConyugBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									socDemConyugBean.setTelEmpresa(socDemConyugBean.getTelEmpresa().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
									socDemConyugBean.setTelCelular(socDemConyugBean.getTelCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
									String query = "call SOCIODEMOCONYUGALT( ?,?,?,?,?,    ?,?,?,?,?,"
																		 + " ?,?,?,?,?,    ?,?,?,?,?,"
																		 + " ?,?,?,?,?,    ?,?,?,?,?,"
																		 + " ?,?,?,?,?,    ?,?,?,?,?,"
																		 + " ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Prospecto",Utileria.convierteEntero(socDemConyugBean.getProspectoID()));
									sentenciaStore.setInt("Par_Cliente",Utileria.convierteEntero( socDemConyugBean.getClienteID() ));
									sentenciaStore.setInt("Par_ClienteConyID",Utileria.convierteEntero( socDemConyugBean.getClienteConyID() ));
									sentenciaStore.setString("Par_PrimerNombre",socDemConyugBean.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNombre",socDemConyugBean.getSegundoNombre());

									sentenciaStore.setString("Par_TercerNombre",socDemConyugBean.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPaterno",socDemConyugBean.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMaterno",socDemConyugBean.getApellidoMaterno());
									sentenciaStore.setString("Par_Nacionalidad",socDemConyugBean.getNacionaID());
									sentenciaStore.setInt("Par_PaisNacimiento",Utileria.convierteEntero(socDemConyugBean.getPaisNacimiento()));

								    sentenciaStore.setInt("Par_EstadoNacimiento",Utileria.convierteEntero( socDemConyugBean.getEstadoID() ));
								    sentenciaStore.setDate("Par_FechaNacimiento", OperacionesFechas.conversionStrDate(socDemConyugBean.getFecNacimiento()));
 								    sentenciaStore.setString("Par_RFC",socDemConyugBean.getRfcConyugue());
								    sentenciaStore.setInt("Par_TipoIdentiID",Utileria.convierteEntero( socDemConyugBean.getTipoIdentiID() ));
								    sentenciaStore.setString("Par_FolioIdentificacion",socDemConyugBean.getFolioIdentificacion());

								    sentenciaStore.setDate("Par_FechaExpedicion", OperacionesFechas.conversionStrDate(socDemConyugBean.getFechaExpedicion()));
								    sentenciaStore.setDate("Par_FechaVencimiento", OperacionesFechas.conversionStrDate(socDemConyugBean.getFechaVencimiento()));
								    sentenciaStore.setString("Par_TelCelular",socDemConyugBean.getTelCelular());
								    sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero( socDemConyugBean.getOcupacionID() ));
								    sentenciaStore.setString("Par_EmpresaLabora",  socDemConyugBean.getEmpresaLabora());

								    sentenciaStore.setInt("Par_EntidadFedTrabajo",Utileria.convierteEntero( socDemConyugBean.getEntFedID() ));
								    sentenciaStore.setInt("Par_MunicipioTrabajo",Utileria.convierteEntero( socDemConyugBean.getMunicipioID() ));
								    sentenciaStore.setInt("Par_LocalidadTrabajo",Utileria.convierteEntero( socDemConyugBean.getLocalidadID()));
								    sentenciaStore.setInt("Par_ColoniaTrabajo",Utileria.convierteEntero( socDemConyugBean.getColoniaID()));
								    sentenciaStore.setString("Par_Colonia",socDemConyugBean.getColonia());

								    sentenciaStore.setString("Par_Calle",socDemConyugBean.getCalle());
								    sentenciaStore.setString("Par_NumeroExterior",socDemConyugBean.getNumero() );
								    sentenciaStore.setString("Par_NumeroInterior",  socDemConyugBean.getInterior());
								    sentenciaStore.setString("Par_CodigoPostal",socDemConyugBean.getCodPostal());
								    sentenciaStore.setString("Par_NumeroPiso",  socDemConyugBean.getPiso());

								    sentenciaStore.setString("Par_AntiguedadAnios",socDemConyugBean.getAniosAnti() );
								    sentenciaStore.setString("Par_AntiguedadMeses",socDemConyugBean.getMesesAnti());
								    sentenciaStore.setString("Par_TelefonoTrabajo",socDemConyugBean.getTelEmpresa());
								    sentenciaStore.setString("Par_ExtencionTrabajo",socDemConyugBean.getExtencionTrabajo());
								    sentenciaStore.setString("Par_FechaIniTrabajo",Utileria.convierteFecha(socDemConyugBean.getFechaIniTrabajo()));

								    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

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
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Conyugue: " + mensajeBean.getDescripcion());
							mensajeBean.setDescripcion("No es posible realizar la operación, la persona hizo coincidencia con la Listas de Personas Bloqueadas");
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de datos conyuge", e);
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


	//alta a historial de datos sociodemograficos
	public MensajeTransaccionBean altaHisDatosConyugue(final SocDemConyugBean socDemConyugBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();


		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call HISSOCIODEMOCONALT(?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Prospecto",Utileria.convierteEntero(socDemConyugBean.getProspectoID()));
									sentenciaStore.setInt("Par_Cliente",Utileria.convierteEntero(socDemConyugBean.getClienteID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Historico Conyugue: " + mensajeBean.getDescripcion());
							mensajeBean.setDescripcion("No es posible realizar la operación, la persona hizo coincidencia con la Listas de Personas Bloqueadas");
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historica de datos del conyuge", e);
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





	public SocDemConyugBean consultaPrincipal(SocDemConyugBean socDemConyugBean, int tipoConsulta) {
		SocDemConyugBean SocDemConyuResulBean = null;
		try{
			//Query con el Store Procedure
			String query = "call SOCIODEMOCONYUGCON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(socDemConyugBean.getProspectoID()),
					Utileria.convierteEntero(socDemConyugBean.getClienteID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SocDemConyugDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOCIODEMOCONYUGCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SocDemConyugBean socDemConyugResBean = new SocDemConyugBean();

					socDemConyugResBean.setProspectoID(resultSet.getString("ProspectoID"));
					socDemConyugResBean.setClienteID(resultSet.getString("ClienteID"));
					socDemConyugResBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					socDemConyugResBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
					socDemConyugResBean.setSegundoNombre(resultSet.getString("SegundoNombre"));
					socDemConyugResBean.setTercerNombre(resultSet.getString("TercerNombre"));
					socDemConyugResBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno")) ;
					socDemConyugResBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					socDemConyugResBean.setNacionaID(resultSet.getString("Nacionalidad"));
					socDemConyugResBean.setPaisNacimiento(resultSet.getString("PaisNacimiento"));
					socDemConyugResBean.setEstadoID(resultSet.getString("EstadoNacimiento"));
					socDemConyugResBean.setFecNacimiento(resultSet.getString("FechaNacimiento"));
					socDemConyugResBean.setRfcConyugue(resultSet.getString("RFC")) ;
					socDemConyugResBean.setTipoIdentiID(resultSet.getString("TipoIdentiID"));
					socDemConyugResBean.setFolioIdentificacion(resultSet.getString("FolioIdentificacion") ) ;
					socDemConyugResBean.setFechaExpedicion(resultSet.getString("FechaExpedicion"));
					socDemConyugResBean.setFechaVencimiento( resultSet.getString("FechaVencimiento")) ;
					socDemConyugResBean.setTelCelular( resultSet.getString("TelCelular")) ;
					socDemConyugResBean.setOcupacionID(resultSet.getString("OcupacionID") ) ;
					socDemConyugResBean.setEmpresaLabora(resultSet.getString("EmpresaLabora")) ;
					socDemConyugResBean.setEntFedID(resultSet.getString("EntidadFedTrabajo"));
					socDemConyugResBean.setMunicipioID(resultSet.getString("MunicipioTrabajo"));
					socDemConyugResBean.setLocalidadID(resultSet.getString("LocalidadTrabajo"));
					socDemConyugResBean.setColoniaID(resultSet.getString("ColoniaTrabajo"));
					socDemConyugResBean.setColonia(resultSet.getString("Colonia")) ;
					socDemConyugResBean.setCalle(resultSet.getString("Calle"));
					socDemConyugResBean.setNumero(resultSet.getString("NumeroExterior")) ;
					socDemConyugResBean.setInterior(resultSet.getString("NumeroInterior"));
					socDemConyugResBean.setCodPostal(resultSet.getString("CodigoPostal"));
					socDemConyugResBean.setPiso(resultSet.getString("NumeroPiso"));
					socDemConyugResBean.setAniosAnti(resultSet.getString("AntiguedadAnios")) ;
					socDemConyugResBean.setMesesAnti(resultSet.getString("AntiguedadMeses"));
					socDemConyugResBean.setTelEmpresa(resultSet.getString("TelefonoTrabajo")) ;
					socDemConyugResBean.setExtencionTrabajo(resultSet.getString("ExtencionTrabajo"));
					socDemConyugResBean.setClienteConyID(resultSet.getString("ClienteConyID"));
					socDemConyugResBean.setFechaIniTrabajo(resultSet.getString("FechaIniTrabajo"));

					return socDemConyugResBean;
				}
			});

			SocDemConyuResulBean= matches.size() > 0 ? (SocDemConyugBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de sociodemografico", e);
		}
		return SocDemConyuResulBean;
	}



}//cierra llave  fin de la clase
