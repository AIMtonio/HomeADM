

package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import herramientas.Constantes;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.SolicitudesArchivoBean;
import soporte.bean.InstrumentosArchivosBean;
import soporte.dao.InstrumentosArchivosDAO;
import soporte.dao.InstrumentosArchivosDAO.Enum_TipoInstrumentos;
import soporte.bean.ClienteArchivosBean;
import soporte.bean.ParamGeneralesBean;
import cliente.bean.ClienteBean;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SolicitudArchivoDAO extends BaseDAO{
	InstrumentosArchivosDAO instrumentosArchivosDAO = null;

	/* Alta de Archivo o Documento Digitalizado de la Solicitud de Crédito	 */
	public MensajeTransaccionArchivoBean altaArchivosSolCredito(final SolicitudesArchivoBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
			mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					 new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SOLICITUDARCHIVOSALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(archivo.getSolicitudCreditoID()));
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(archivo.getTipoDocumentoID()));
							sentenciaStore.setString("Par_Comentario",archivo.getComentario());
							sentenciaStore.setString("Par_Recurso",archivo.getRecurso());
							sentenciaStore.setString("Par_Extension",archivo.getExtension());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","CreditoArchivoDAO");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccionArchivoBean.setRecursoOrigen(resultadosStore.getString(5));

							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccionArchivoBean;
						}
					}
					);

				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionArchivoBean();
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de archivo de credito ", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}

	/* Baja de Archivo o Documento Digitalizado de Solicitud de Crédito	 */
	public MensajeTransaccionArchivoBean bajaArchivosSolCredito(final SolicitudesArchivoBean archivo, final int tipoBaja) {

		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();

		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();

				try {

			mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					 new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call SOLICITUDARCHIVOSBAJ(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(archivo.getSolicitudCreditoID()));
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(archivo.getTipoDocumentoID()));
							sentenciaStore.setInt("Par_DigSolCreditoID",Utileria.convierteEntero(archivo.getDigSolID()));
							sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CreditoArchivoDAO");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
					        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){

								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));

							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccionArchivoBean;
						}
					}
					);

				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionArchivoBean();
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de archivos de Solicitud de Crédito", e);

			}
			return mensajeBean;
		}
	});
	return mensaje;
}
	/* Lista de Archivos por Solicitud de Crédito*/
	public List listaArchivosSolCredito(SolicitudesArchivoBean archivoBean, int tipoLista) {
		// TODO Auto-generated method stub
		String query = "call SOLICITUDARCHIVOSLIS (?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros ={
				archivoBean.getSolicitudCreditoID(),
				archivoBean.getTipoDocumentoID(),
				archivoBean.getComentario(),
				archivoBean.getRecurso(),
				Constantes.FECHA_VACIA,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"SolicitudArchivoDAO.listaArchivosSol",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDARCHIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudesArchivoBean archivoBean = new SolicitudesArchivoBean();

				archivoBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				archivoBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
				archivoBean.setComentario(resultSet.getString("Comentario"));
				archivoBean.setRecurso(resultSet.getString("Recurso"));
				archivoBean.setDescripcion(resultSet.getString("Descripcion"));
				archivoBean.setGrupoID(resultSet.getString("GrupoID"));
				archivoBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
				archivoBean.setCiclo(resultSet.getString("CicloGrupo"));

				return archivoBean;
			}
		});

		return matches;
	}

	// lista de documentos requeridos por producto de crédito
		public List listaDocumentosRequeridosProducto(SolicitudesArchivoBean archivoBean, int tipoLista){
			String query = "call SOLICIDOCREQLIS(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

						Constantes.ENTERO_CERO,
						Utileria.convierteEntero(archivoBean.getProductoCreditoID()),
						archivoBean.getDescripcion(),
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
					SolicitudesArchivoBean archivoBean = new SolicitudesArchivoBean();
					archivoBean.setTipoDocumentoID(String.valueOf(resultSet.getInt(1)));;
					archivoBean.setDescripcion(resultSet.getString(2));
					return archivoBean;

				}
			});
			return matches;
			}


	/* Lista de Archivos de Solicitud de Crédito por tipo de documento*/

	public List listaArchivosSolCreditoTipoDoc(SolicitudesArchivoBean solicitudesArchivoBean, int tipoLista) {
		// TODO Auto-generated method stub
		String query = "call SOLICITUDARCHIVOSLIS (?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros ={
				solicitudesArchivoBean.getSolicitudCreditoID(),
				solicitudesArchivoBean.getTipoDocumentoID(),
				solicitudesArchivoBean.getComentario(),
				solicitudesArchivoBean.getRecurso(),
				Constantes.FECHA_VACIA,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"SolicitudArchivoDAO.listaArchivosSolCreditoTipoDoc",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDARCHIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudesArchivoBean archivoBean = new SolicitudesArchivoBean();
				archivoBean.setDigSolID(String.valueOf(resultSet.getInt(1)));
				archivoBean.setSolicitudCreditoID(resultSet.getString(2));
				archivoBean.setTipoDocumentoID(resultSet.getString(3));
				archivoBean.setRecurso(resultSet.getString(6));
				archivoBean.setComentario(resultSet.getString(5));
				archivoBean.setVoBoAnalista(resultSet.getString("VoBoAnalista"));
				archivoBean.setComentarioAnalista(resultSet.getString("ComentarioAnalista"));
				archivoBean.setDescTipoDoc(resultSet.getString("Descripcion"));

				return archivoBean;
			}
		});


		return matches;
	}
	//Consulta para saber cuantos documentos digitalizados tiene la Solicitud de  Crédito
	public SolicitudesArchivoBean consultaCantDocumentos(SolicitudesArchivoBean archivo, int tipoConsulta) {
		SolicitudesArchivoBean solicitudesArchivoBeanConsulta = new SolicitudesArchivoBean();
		try{
			//Query con el Store Procedure
			String query = "call SOLICITUDARCHIVOSCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {archivo.getSolicitudCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SolicitudArchivoDAO.consultaCantDocumentos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDARCHIVOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudesArchivoBean archivo = new SolicitudesArchivoBean();
						archivo.setNumeroDocumentos(String.valueOf(resultSet.getInt(1)));
						return archivo;

				}

			});

		solicitudesArchivoBeanConsulta =  matches.size() > 0 ? (SolicitudesArchivoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de archivos de solicitud de credito", e);
		}
		return solicitudesArchivoBeanConsulta;
	}
	/**
	 * @author olegario
	 * @descripcion: Metodo para realizar el proceso actualizacion
	 * */
	 public MensajeTransaccionArchivoBean procesoActualizacionAnalista(final SolicitudesArchivoBean archivosBean, final List listaAnalista) {
		 MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();

		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				int actualizacion = 1;
				try {
					SolicitudesArchivoBean solicitudesArchivoBean;
					for(int i=0; i<listaAnalista.size(); i++){

						solicitudesArchivoBean = (SolicitudesArchivoBean)listaAnalista.get(i);
						solicitudesArchivoBean.setSolicitudCreditoID(archivosBean.getSolicitudCreditoID());
						solicitudesArchivoBean.setTipoDocumentoID(archivosBean.getTipoDocumentoID());
						mensajeBean = actualizacionAnalista(solicitudesArchivoBean, actualizacion);

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
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de archivos del analista", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	 /* Baja de Archivo o Documento Digitalizado de Solicitud de Crédito	 */
		public MensajeTransaccionArchivoBean actualizacionAnalista(final SolicitudesArchivoBean archivo, final int actualizacion) {
			MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
					try {
				mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						 new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL SOLICITUDARCHIVOSACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(archivo.getSolicitudCreditoID()));
								sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(archivo.getTipoDocumentoID()));
								sentenciaStore.setInt("Par_DigSolCreditoID",Utileria.convierteEntero(archivo.getDigSolID()));
								sentenciaStore.setString("Par_VoBoAnalista", archivo.getVoBoAnalista());
								sentenciaStore.setString("Par_ComentarioAnalista", archivo.getComentarioAnalista());

								sentenciaStore.setInt("Par_NumAct",actualizacion);

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
								MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
								if(callableStatement.execute()){

									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString("Consecutivo"));
								}else{
									mensajeTransaccionArchivoBean.setNumero(999);
									mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccionArchivoBean;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionArchivoBean();
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion del archivo de solicitud", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
		public  ParamGeneralesBean consultaSizeArchivo(ParamGeneralesBean param,int tipoConsulta) {

			ParamGeneralesBean paramGenerales = new ParamGeneralesBean();
			loggerSAFI.info("486-consultaSizeArchivo");
			try{
				//Query con el Store Procedure
				String query = "call TAMAARCHIVOCON(?,?,?,?,?,?,?,?);";
				Object[] parametros = {
										Constantes.ENTERO_UNO,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"SolicitudArchivoDAO.consultaSizeArchivo",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TAMAARCHIVOCON(  " + Arrays.toString(parametros) + ")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
						paramGeneralesBean.setValorParametro(String.valueOf(resultSet.getInt(1)));
						return paramGeneralesBean;
					}
				});
				return matches.size() > 0 ? (ParamGeneralesBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta", e);

			}
			return paramGenerales;

		}

		public MensajeTransaccionArchivoBean procBajaArchivosSolCredito(final SolicitudesArchivoBean archivo,final int tipoBaja) {
			MensajeTransaccionArchivoBean mensaje = null;

			final InstrumentosArchivosBean instrumArchivo = new InstrumentosArchivosBean();
			instrumArchivo.setArchivoBajID(archivo.getDigSolID());
			instrumArchivo.setNumeroInstrumento(archivo.getSolicitudCreditoID());
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
					try {
							mensajeBean = instrumentosArchivosDAO.altaArchivosAEliminar(instrumArchivo,Enum_TipoInstrumentos.solCred);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean = bajaArchivosSolCredito(archivo,tipoBaja);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
					}catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Archivos Eliminados de Solicitud Credito.", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		public InstrumentosArchivosDAO getInstrumentosArchivosDAO() {
			return instrumentosArchivosDAO;
		}

		public void setInstrumentosArchivosDAO(
				InstrumentosArchivosDAO instrumentosArchivosDAO) {
			this.instrumentosArchivosDAO = instrumentosArchivosDAO;
		}
}
