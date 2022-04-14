package ventanilla.dao;
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
import java.util.StringTokenizer;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cuentas.bean.CuentasFirmaBean;
import ventanilla.bean.OpcionesPorCajaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class OpcionesPorCajaDAO extends BaseDAO{
	public OpcionesPorCajaDAO(){
		super();
	}

	private final static String salidaPantalla = "S";

	/* Alta de opciones por caja*/
	public MensajeTransaccionBean altaOpcionesPorCaja(final OpcionesPorCajaBean opcionesPorCajaBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
//		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

//					mensajeBean = bajaOpcionesPorCaja(opcionesPorCajaBean);
//					if(mensajeBean.getNumero() == 0){
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call OPCIONESPORCAJAALT(?,?,?,?,?,  ?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_OpcionCajaID", Utileria.convierteEntero(opcionesPorCajaBean.getOpcionCajaID()));
									sentenciaStore.setString("Par_TipoCaja", opcionesPorCajaBean.getTipoCaja());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OpcionesPorCajaDAO.altaOpcionesPorCaja");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);
//					}
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .OpcionesPorCajaDAO.altaOpcionesPorCaja");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro Opciones por Caja" + e);
						e.printStackTrace();
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



	public List listaComboOpciones(final OpcionesPorCajaBean opcionesPorCajaBean,int tipoLista){
		List opciones=null;
		try{
			String query = "call OPCIONESPORCAJALIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {	opcionesPorCajaBean.getTipoCaja(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"OpcionesPorCajaDAO.listaCombo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESPORCAJALIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OpcionesPorCajaBean opcionCaja = new OpcionesPorCajaBean();
					opcionCaja.setOpcionCajaID(String.valueOf(resultSet.getInt("OpcionCajaID")));
					opcionCaja.setDescripcion(resultSet.getString("Descripcion"));
					return opcionCaja;
				}
			});
				opciones= matches;

	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Opciones por caja: "+ e);
	}
		return opciones;
	}

	// Lista las operaciones que si parametrizaron como sujetas de PLD

	public List listaOpcionesSujetas(final OpcionesPorCajaBean opcionesPorCajaBean,int tipoLista){
		List opciones=null;
		try{
			String query = "call OPCIONESPORCAJALIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {	opcionesPorCajaBean.getTipoCaja(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"OpcionesPorCajaDAO.listaCombo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESPORCAJALIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OpcionesPorCajaBean opcionCaja = new OpcionesPorCajaBean();
					opcionCaja.setOpcionCajaID(String.valueOf(resultSet.getInt("OpcionCajaID")));
					opcionCaja.setSujetoPLDEscala(resultSet.getString("SujetoPLDEscala"));
					opcionCaja.setSujetoPLDIdenti(resultSet.getString("SujetoPLDIdenti"));
					return opcionCaja;
				}
			});
				opciones= matches;

	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Opciones por caja: "+ e);
	}
		return opciones;
	}

	public OpcionesPorCajaBean consultaPrincipal(final OpcionesPorCajaBean opcionesPorCajaBean,int tipoConsulta){
		String query = "call OPCIONESCAJACON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				opcionesPorCajaBean.getOpcionCajaID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"OpcionesPorCajaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESCAJACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpcionesPorCajaBean opcionesPorCajaBean = new OpcionesPorCajaBean();
				opcionesPorCajaBean.setOpcionCajaID(Utileria.completaCerosIzquierda(resultSet.getInt(1),CuentasFirmaBean.LONGITUD_ID));
				opcionesPorCajaBean.setDescripcion(resultSet.getString(2));
				opcionesPorCajaBean.setEsReversa(resultSet.getString(3));
				opcionesPorCajaBean.setReqAutentificacion(resultSet.getString(4));
				return opcionesPorCajaBean;
			}
		});
		return matches.size() > 0 ? (OpcionesPorCajaBean) matches.get(0) : null;
	}

	// Elimina los registros de tabla OPCIONESPORCAJA
	public MensajeTransaccionBean bajaOpcionesPorCaja(final OpcionesPorCajaBean opcionesPorCajaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					String query = "call OPCIONESPORCAJABAJ(?,?,?, ?,?,?,?,?,?);";


					Object[] parametros = {
							opcionesPorCajaBean.getTipoCaja(),
							Constantes.salidaSI,
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"OpcionesPorCajaDAO.bajaOpcionesPorCaja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESPORCAJABAJ(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(resultSet.getString(4));
							return mensaje;
						}
					});

					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
                  e.printStackTrace();
                  loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Opciones por Caja", e);
					if(mensajeBean.getNumero()==0){
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

	// Metodo que actualiza las opciones de caja para PLD
	public MensajeTransaccionBean actualizaOpcPLD(final OpcionesPorCajaBean opcionesPorCajaBean, final int tipoActualizacion){
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Array de beans que almacena todas las cajas que tendran la chequera seleccionada
					ArrayList opcionesCajasPLD=(ArrayList) creaListaOpcionesPLD(opcionesPorCajaBean);
					if(!opcionesCajasPLD.isEmpty()){
						for(int i=0;i<opcionesCajasPLD.size();i++){
							final OpcionesPorCajaBean opcionesPorCajaBean=(OpcionesPorCajaBean)opcionesCajasPLD.get(i);
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

										String query = "call OPCIONESCAJAACT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_OpcionCajaID",Utileria.convierteEntero(opcionesPorCajaBean.getOpcionCajaID()));
											sentenciaStore.setString("Par_SujetoPLDEscala",opcionesPorCajaBean.getSujetoPLDEscala());
											sentenciaStore.setString("Par_SujetoPLDIdenti", opcionesPorCajaBean.getSujetoPLDIdenti());
											sentenciaStore.setInt("Par_TipoActualizacion", tipoActualizacion);
											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

											sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
											sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);
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
											}else{
												mensajeTransaccion.setNumero(999);
												mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OpcionesPorCajaDAO.actualizaOpcPLD");
												mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
												mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
											}
											return mensajeTransaccion;
										}
								});

								if(mensajeBean ==  null){
									mensajeBean = new MensajeTransaccionBean();
									mensajeBean.setNumero(999);
									throw new Exception(Constantes.MSG_ERROR + " .OpcionesPorCajaDAO.actualizaOpcPLD");
								}else if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
						}
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operaciones Sujetas a PLD Agregadas Exitosamente.");
						mensajeBean.setNombreControl("numCtaInstit");

					}else{
						mensajeBean =new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No se Agregaron las operaciones Sujetas a PLD.");
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al asignar Operaciones Sujetas a PLD " + e);
					e.printStackTrace();
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

	// Metodo que arma los beans a partir de una lista
	private List creaListaOpcionesPLD(OpcionesPorCajaBean opcionesPorCajaBean){
		StringTokenizer tokensBean = new StringTokenizer(opcionesPorCajaBean.getListaOpcionesPLD(), "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaBeanCheques = new ArrayList();
		OpcionesPorCajaBean opcionesBean;

		while (tokensBean.hasMoreTokens()) {
			opcionesBean = new OpcionesPorCajaBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

			opcionesBean.setOpcionCajaID(tokensCampos[0]);
			opcionesBean.setSujetoPLDIdenti(tokensCampos[1]);
			opcionesBean.setSujetoPLDEscala(tokensCampos[2]);

			listaBeanCheques.add(opcionesBean);

		}
		return listaBeanCheques;
	}
}
