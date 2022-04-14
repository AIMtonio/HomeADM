package originacion.dao;
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

import originacion.bean.SolicitudCheckListBean;
import sms.bean.SMSCapaniasBean;
import sms.bean.SMSCodigosRespBean;
public class SolicitudCheckListDAO extends BaseDAO{

	public SolicitudCheckListDAO() {
		super();
	}

	// Actualiza Lista de documentos entregados por solicitud
	public MensajeTransaccionBean actualizaListaDocEntregados( final SolicitudCheckListBean solicitudCheckListBean, final int tipoTransaccion) {
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
								String query = "call SOLICIDOCENTACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_Solicitud",Utileria.convierteEntero(solicitudCheckListBean.getSolicitudCreditoID()));
								sentenciaStore.setInt("Par_ClasificaTipDocID",Utileria.convierteEntero(solicitudCheckListBean.getClasificaTipDocID()));
								sentenciaStore.setString("Par_DocRecibido",solicitudCheckListBean.getDocRecibido());
								sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(solicitudCheckListBean.getTipoDocumentoID()));
								sentenciaStore.setString("Par_Comentarios",solicitudCheckListBean.getComentarios());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de documentos entregados", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



   public MensajeTransaccionBean actualizaListaCodigosResp( SolicitudCheckListBean solicitudCheckListBean, int tipoTransaccion, final List listaCodigosResp) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					SolicitudCheckListBean solicitudCheckListBean;
					  String consecutivo= mensajeBean.getConsecutivoString();
					  int tipoTransaccion=1;
						for(int i=0; i<listaCodigosResp.size(); i++){
							solicitudCheckListBean = (SolicitudCheckListBean)listaCodigosResp.get(i);
							mensajeBean = actualizaListaDocEntregados(solicitudCheckListBean, tipoTransaccion);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de codigos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


		// Lista de Documentos Requeridos CheckList
	public List listaSolCheckListGrid(SolicitudCheckListBean solicitudCheckList, int tipoLista){
		String query = "call SOLICIDOCENTLIS(?,?);";
		Object[] parametros = {
					Utileria.convierteEntero(solicitudCheckList.getSolicitudCreditoID()),
					tipoLista
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICIDOCENTLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCheckListBean solicitudCheckListBean = new SolicitudCheckListBean();

				solicitudCheckListBean.setSolicitudCreditoID(resultSet.getString(1));
				solicitudCheckListBean.setProductoCreditoID(resultSet.getString(2));
				solicitudCheckListBean.setClasificaTipDocID(resultSet.getString(3));
				solicitudCheckListBean.setClasificaDesc(resultSet.getString(4));
				solicitudCheckListBean.setDocRecibido(resultSet.getString(5));
				solicitudCheckListBean.setTipoDocumentoID(resultSet.getString(6));
				solicitudCheckListBean.setDescripcion(resultSet.getString(7));
				solicitudCheckListBean.setComentarios(resultSet.getString(8));

				return solicitudCheckListBean;
			}
		});
		return matches;
	}

	// Lista de tipos de documentos Grid combos
	public List listaSolCheckListLista(int tipoLista,  SolicitudCheckListBean solicitudCheckList){
		String query = "call SOLICIDOCREQLIS(?,?,?,?," +
											"?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(solicitudCheckList.getClasificaTipDocID()),
				Utileria.convierteEntero(solicitudCheckList.getProductoCreditoID()),
				solicitudCheckList.getDescripcion(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICIDOCREQLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCheckListBean solicitudCheckListBean = new SolicitudCheckListBean();

				solicitudCheckListBean.setTipoDocumentoID(resultSet.getString(1));
				solicitudCheckListBean.setDescripcion(resultSet.getString(2));

				return solicitudCheckListBean;
			}
		});
		return matches;
	}



	// Lista de tipos de documentos Grid combos
	public List listaGuardaValores(final SolicitudCheckListBean solicitudCheckList, int tipoLista ){

		List<SolicitudCheckListBean> listaSolicitudCheckList = null;
		//Query con el Store Procedure
		try{
			String query = "call SOLICIDOCREQLIS(?,?,?,?," +
												"?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(solicitudCheckList.getClasificaTipDocID()),
					Utileria.convierteEntero(solicitudCheckList.getProductoCreditoID()),
					solicitudCheckList.getDescripcion(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SOLICIDOCREQLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCheckListBean solicitudCheckListBean = new SolicitudCheckListBean();

					solicitudCheckListBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					solicitudCheckListBean.setDescripcion(resultSet.getString("Descripcion"));

					return solicitudCheckListBean;
				}
			});

			listaSolicitudCheckList = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en lista de ayuda de Documentos de Solicitud den Guarda Valores ", exception);
			listaSolicitudCheckList = null;
		}

		return listaSolicitudCheckList;
	}

}
