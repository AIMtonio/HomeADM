package soporte.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.ClasificaGrpDoctosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ClasificaGrpDoctosDAO extends BaseDAO{
String salidaPantalla="S";
	public ClasificaGrpDoctosDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* ALTA DE TIPOS DE DOCUMENTOS POR GRUPO */
	public MensajeTransaccionBean altaClasificacion(final ClasificaGrpDoctosBean clasificaGrpDoctosBean) {
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
									String query = "call DOCTOPORGRUPOALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_GrupoDocumentoID",Utileria.convierteEntero(clasificaGrpDoctosBean.getGrupoDocumentoID()));
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(clasificaGrpDoctosBean.getTipoDocumentoID()));

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClasificaGrpDoctosDAO.actClasificacion");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClasificaGrpDoctosDAO.actClasificacion");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Captura de Grupo de Documentos" + e);
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

	/* BAJA DE TIPOS DE DOCUMENTOS */
	public MensajeTransaccionBean bajaClasificacionPorGrupo(final ClasificaGrpDoctosBean clasificaGrpDoctosBean) {
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
									String query = "call DOCTOPORGRUPOBAJ(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_GrupoDocumentoID",Utileria.convierteEntero(clasificaGrpDoctosBean.getGrupoDocumentoID()));
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(clasificaGrpDoctosBean.getTipoDocumentoID()));

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClasificaGrpDoctosDAO.bajaClasificacionPorGrupo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClasificaGrpDoctosDAO.bajaClasificacionPorGrupo");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Grupo de Documentos" + e);
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



	/* METODO PARA ALTA Y BAJA DE TIPOS DE DOCUMENTOS POR GRUPO*/
	public MensajeTransaccionBean metodoActClasifica(final List listaBean,
													 final List listaBaja) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					ClasificaGrpDoctosBean bajaTiposDocumentos;
					ClasificaGrpDoctosBean altaTiposDocumentos;
					// SE MANDA A LLAMAR AL STORE DE BAJA POR SI EXISTEN ELEMENTOS ELIMINADOS
					if(listaBaja!=null){
						for(int i=0; i<listaBaja.size(); i++){
							bajaTiposDocumentos = (ClasificaGrpDoctosBean)listaBaja.get(i);
							bajaTiposDocumentos.setGrupoDocumentoID(bajaTiposDocumentos.getNumeroGrupo());
							mensajeBean = bajaClasificacionPorGrupo(bajaTiposDocumentos);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					//SE MANDA A LLAMAR EL STORE DE ALTA POR SI EXISTEN ELEMENTOS AGREGADOS
					if(listaBean!=null){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							altaTiposDocumentos = (ClasificaGrpDoctosBean)listaBean.get(i);
							altaTiposDocumentos.setGrupoDocumentoID(altaTiposDocumentos.getNumeroGrupo());
							mensajeBean = altaClasificacion(altaTiposDocumentos);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta/Baja Tipos de Documentos para un Grupo", e);
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

	}// fin de Metodo

	//Lista de para combo
	public List listaCombo(ClasificaGrpDoctosBean clasificaGrpDoctosBean, int tipoLista) {
		//Query con el Store Procedure
		List clasificaGrpDoctos = null;
		try{
		String query = "call DOCTOPORGRUPOLIS(?,?,?" +
											",?,?,?,?,?,?,?);";
		Object[] parametros = {
								tipoLista,
								clasificaGrpDoctosBean.getGrupoDocumentoID(),
								Constantes.STRING_VACIO,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"listaCombo",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOCTOPORGRUPOLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClasificaGrpDoctosBean clasifica = new ClasificaGrpDoctosBean();
				clasifica.setTipoDocumentoID(resultSet.getString(1));
				clasifica.setDescripcion(resultSet.getString(2));

				return clasifica;
			}
		});

		clasificaGrpDoctos =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en combo de Grupo de Documentos", e);
		}
		return clasificaGrpDoctos;
	}

	//Lista de ayuda Guarda Valores
	public List listaGuardaValores(final ClasificaGrpDoctosBean clasificaGrpDoctosBean, final int tipoLista) {

		List listaClasificaGrpDoctos = null;
		try{
			//Query con el Store Procedure
			String query = "CALL DOCTOPORGRUPOLIS(?,?,?," +
												 "?,?,?,?,?,?,?);";
			Object[] parametros = {
				tipoLista,
				Utileria.convierteEntero(clasificaGrpDoctosBean.getGrupoDocumentoID()),
				clasificaGrpDoctosBean.getDescripcion(),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ClasificaGrpDoctosDAO.listaGuardaValores",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL DOCTOPORGRUPOLIS(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClasificaGrpDoctosBean clasificaGrpDoctos = new ClasificaGrpDoctosBean();
					clasificaGrpDoctos.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					clasificaGrpDoctos.setDescripcion(resultSet.getString("Descripcion"));
					return clasificaGrpDoctos;
				}
			});

			listaClasificaGrpDoctos =  matches;
		} catch(Exception exception) {
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la lista de Grupos de Documentos para Guarda Valores", exception);
		}
		return listaClasificaGrpDoctos;
	}

}
