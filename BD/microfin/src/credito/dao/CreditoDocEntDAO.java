package credito.dao;
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



import credito.bean.CreditoDocEntBean;

public class CreditoDocEntDAO extends BaseDAO{

	public CreditoDocEntDAO() {
		super();
	}


	// Actualiza Lista de documentos entregados por solicitudCreditoDocEntBean
		public MensajeTransaccionBean actualizaListaDocEntregados( final CreditoDocEntBean creditoDocEntBean, final int tipoTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CREDITODOCENTACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditoDocEntBean.getCreditoID()));
									sentenciaStore.setInt("Par_ClasificaTipDocID",Utileria.convierteEntero(creditoDocEntBean.getClasificaTipDocID()));
									sentenciaStore.setString("Par_DocAceptado",creditoDocEntBean.getDocAceptado());
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(creditoDocEntBean.getTipoDocumentoID()));
									sentenciaStore.setString("Par_Comentarios",creditoDocEntBean.getComentarios());

									sentenciaStore.setInt("Par_TipAct",tipoTransaccion);

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

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de documentos", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



	   public MensajeTransaccionBean actualizaDocEnt( int tipoTransaccion, final List listaDocEnt) {
		   tipoTransaccion=1;
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						CreditoDocEntBean creditoDocEntBean;
						  String consecutivo= mensajeBean.getConsecutivoString();
						  int tipoTransaccion=1;
							for(int i=0; i<listaDocEnt.size(); i++){
								creditoDocEntBean = (CreditoDocEntBean)listaDocEnt.get(i);
								mensajeBean = actualizaListaDocEntregados(creditoDocEntBean, tipoTransaccion);

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de documentos", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		// Lista de Documentos entregados credito grupal
	public List listaDocEntregados(CreditoDocEntBean creditoDocEntBean, int tipoLista){
		String query = "call CREDITODOCENTLIST(?,?,?,?);";
		Object[] parametros = {
					creditoDocEntBean.getCreditoID(),
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoLista
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITODOCENTLIST(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditoDocEntBean creditoGrDocEntBean = new CreditoDocEntBean();

				creditoGrDocEntBean.setCreditoID(resultSet.getString(1));
				creditoGrDocEntBean.setProductoCreditoID(resultSet.getString(2));
				creditoGrDocEntBean.setClasificaTipDocID(resultSet.getString(3));
				creditoGrDocEntBean.setClasificaDesc(resultSet.getString(4));
				creditoGrDocEntBean.setDocAceptado(resultSet.getString(5));
				creditoGrDocEntBean.setTipoDocumentoID(resultSet.getString(6));
				creditoGrDocEntBean.setDescripcion(resultSet.getString(7));
				creditoGrDocEntBean.setComentarios(resultSet.getString(8));

				return creditoGrDocEntBean;
			}
		});
		return matches;
	}

	// Lista de Documentos entregados credito
	public List listaGuardaValores(CreditoDocEntBean creditoDocEntBean, int tipoLista){
		List listaGrupoDocumentos = null;
		try{

			String query = "CALL CREDITODOCENTLIST(?,?,?,?);";
			Object[] parametros = {
					creditoDocEntBean.getCreditoID(),
					creditoDocEntBean.getClasificaTipDocID(),
					creditoDocEntBean.getDescripcion(),
					tipoLista
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CREDITODOCENTLIST(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditoDocEntBean creditoGrDocEntBean = new CreditoDocEntBean();

					creditoGrDocEntBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					creditoGrDocEntBean.setDescripcion(resultSet.getString("Descripcion"));

					return creditoGrDocEntBean;
				}
			});
			listaGrupoDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Grupo de Documentos de Credto en Guarda Valores", exception);
			listaGrupoDocumentos = null;
		}

		return listaGrupoDocumentos;
	}


	// Lista de Documentos entregados credito
	public List listaCombo(CreditoDocEntBean creditoDocEntBean, int tipoLista){
		List listaGrupoDocumentos = null;
		try{
			String query = "CALL CREDITODOCENTLIST(?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteLong(creditoDocEntBean.getCreditoID()),
						Utileria.convierteEntero(creditoDocEntBean.getClasificaTipDocID()),
						Constantes.STRING_VACIO,
						tipoLista
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CREDITODOCENTLIST(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditoDocEntBean creditoGrDocEntBean = new CreditoDocEntBean();

					creditoGrDocEntBean.setClasificaTipDocID(resultSet.getString("ClasificaTipDocID"));
					creditoGrDocEntBean.setDescripcion(resultSet.getString("Descripcion"));
					return creditoGrDocEntBean;
				}
			});

			listaGrupoDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Grupo de Documentos de Credto en Guarda Valores", exception);
			listaGrupoDocumentos = null;
		}

		return listaGrupoDocumentos;
	}
}
