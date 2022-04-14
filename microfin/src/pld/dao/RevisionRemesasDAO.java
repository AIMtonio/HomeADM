package pld.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import pld.bean.RevisionRemesasBean;

public class RevisionRemesasDAO extends BaseDAO{
	
	public RevisionRemesasDAO(){
		super();
	}
	

	// Grabar Revisión de Remesas
	public MensajeTransaccionBean grabarRevisionRemesas(final RevisionRemesasBean revisionRemesasBean) {
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

								String query = "CALL REVISIONREMESASPRO(?,?,?,?,?," +
															   "?,?,?,?,?," +
															   "?,?,?,?,?," +
															   "?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_RemesaFolioID",revisionRemesasBean.getRemesaFolioID());
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(revisionRemesasBean.getClienteID()));
								sentenciaStore.setInt("Par_UsuarioServicioID",Utileria.convierteEntero(revisionRemesasBean.getUsuarioServicioID()));
								sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(revisionRemesasBean.getMonto()));
								sentenciaStore.setString("Par_FormaPago",revisionRemesasBean.getFormaPago());
								
								sentenciaStore.setString("Par_PermiteOperacion",revisionRemesasBean.getPermiteOperacion());
								sentenciaStore.setString("Par_Comentario",revisionRemesasBean.getComentario());

								//Parametros de Salida
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RevisionRemesasDAO.grabarRevisionRemesas");
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
						throw new Exception(Constantes.MSG_ERROR + " .RevisionRemesasDAO.grabarRevisionRemesas");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Grabar Revisión de Remesas: " + e);
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
	
	// Alta de Documentos de Remesas
	public MensajeTransaccionArchivoBean altaDocumentosRemesas(final RevisionRemesasBean revisionRemesasBean) {
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
								String query = "call CHECKLISTREMESASWSALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?);";
						      
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								
								sentenciaStore.setString("Par_RemesaFolioID",revisionRemesasBean.getRemesaFolioID());
								sentenciaStore.setLong("Par_CheckListRemWSID",Utileria.convierteLong(revisionRemesasBean.getCheckListRemWSID()));
								sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(revisionRemesasBean.getTipoDocumentoID()));
								sentenciaStore.setString("Par_Descripcion",revisionRemesasBean.getDescripcionDoc());
								sentenciaStore.setString("Par_Recurso",revisionRemesasBean.getRecurso());
								
								sentenciaStore.setString("Par_Extension",revisionRemesasBean.getExtension());
								
								//Parametros de OutPut
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditoArchivoDAO");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
						
			
								loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Documento de Remesas. ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	// Consulta de Referencias de Remesas
	public RevisionRemesasBean consultaRefereRemesas(RevisionRemesasBean revisionRemesasBean, int tipoConsulta) {
		RevisionRemesasBean revisionRemesas = null;
		try{
			//Query con el Store Procedure
			String query = "call REMESASWSCON(?,?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {	
						Constantes.ENTERO_CERO,
						revisionRemesasBean.getRemesaFolioID(),
						revisionRemesasBean.getClabeCobroRemesa(),
						tipoConsulta,
						
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"RevisionRemesasBean.consultaRefereRemesa",
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REMESASWSCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RevisionRemesasBean revisionRemesasBean = new RevisionRemesasBean();

						revisionRemesasBean.setRemesadora(resultSet.getString("Remesadora"));
						revisionRemesasBean.setClienteID(resultSet.getString("ClienteID"));
						revisionRemesasBean.setUsuarioServicioID(resultSet.getString("UsuarioServicioID"));
						revisionRemesasBean.setMonto(resultSet.getString("Monto"));
						revisionRemesasBean.setDireccion(resultSet.getString("Direccion"));

						revisionRemesasBean.setMotivoRevision(resultSet.getString("MotivoRevision"));
						revisionRemesasBean.setFormaPago(resultSet.getString("FormaPago"));
						revisionRemesasBean.setIdentificacion(resultSet.getString("Identificacion"));
						revisionRemesasBean.setEstatus(resultSet.getString("Estatus"));

						return revisionRemesasBean;
				}
			});
			revisionRemesas= matches.size() > 0 ? (RevisionRemesasBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Referencia de Remesas.", e);

		}
		return revisionRemesas;
	}
	
	// Consulta de Referencias de Remesas EN VETANILLA
	public RevisionRemesasBean conRefereClabeCobRemesas(RevisionRemesasBean revisionRemesasBean, int tipoConsulta) {
		RevisionRemesasBean revisionRemesas = null;
		try{
			//Query con el Store Procedure
			String query = "call REMESASWSCON(?,?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {	
						Constantes.ENTERO_CERO,
						revisionRemesasBean.getRemesaFolioID(),
						revisionRemesasBean.getClabeCobroRemesa(),
						tipoConsulta,
						
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"RevisionRemesasBean.conRefereClabeCobRemesas",
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REMESASWSCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RevisionRemesasBean revisionRemesasBean = new RevisionRemesasBean();

						revisionRemesasBean.setRemesaFolioID(resultSet.getString("RemesaFolioID"));
						revisionRemesasBean.setClabeCobroRemesa(resultSet.getString("ClabeCobroRemesa"));
						revisionRemesasBean.setMonto(resultSet.getString("Monto"));
						revisionRemesasBean.setRemesadora(resultSet.getString("RemesaCatalogoID"));
						revisionRemesasBean.setClienteID(resultSet.getString("ClienteID"));
						
						revisionRemesasBean.setDireccion(resultSet.getString("Direccion"));						
						revisionRemesasBean.setUsuarioServicioID(resultSet.getString("UsuarioServicioID"));
						revisionRemesasBean.setNumTelefonico(resultSet.getString("NumTelefonico"));
						revisionRemesasBean.setTipoIdentiID(resultSet.getString("TipoIdentiID"));
						revisionRemesasBean.setFolioIdentific(resultSet.getString("FolioIdentific"));

						revisionRemesasBean.setNombreCompletoRemit(resultSet.getString("NombreCompletoRemit"));
						revisionRemesasBean.setPaisIDRemitente(resultSet.getString("PaisIDRemitente"));
						revisionRemesasBean.setEstadoIDRemitente(resultSet.getString("EstadoIDRemitente"));
						revisionRemesasBean.setCiudadIDRemitente(resultSet.getString("CiudadIDRemitente"));
						revisionRemesasBean.setColoniaIDRemitente(resultSet.getString("ColoniaIDRemitente"));
						
						revisionRemesasBean.setCodigoPostalRemitente(resultSet.getString("CodigoPostalRemitente"));
						revisionRemesasBean.setDirecRemitente(resultSet.getString("DirecRemitente"));
						revisionRemesasBean.setEstatus(resultSet.getString("Estatus"));
						revisionRemesasBean.setPermiteOperacion(resultSet.getString("PermiteOperacion"));
						revisionRemesasBean.setFormaPago(resultSet.getString("FormaPago"));

						return revisionRemesasBean;
				}
			});
			revisionRemesas= matches.size() > 0 ? (RevisionRemesasBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Referencia de Remesas.", e);

		}
		return revisionRemesas;
	}
	
	// Función para consultar los Documentos del Check List de Remesa
	public RevisionRemesasBean consultaDocumentosCheckListRemesa(RevisionRemesasBean revisionRemesasBean, int tipoConsulta) {
		RevisionRemesasBean revisionRemesas  = null; 
		try{
			//Query con el Store Procedure
			String query = "call CHECKLISTREMESASWSCON(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {	
						Constantes.ENTERO_CERO,
						revisionRemesasBean.getRemesaFolioID(),
						tipoConsulta,
						
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"RevisionRemesasBean.consultaDocCheckListRemesa",
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHECKLISTREMESASWSCON(" + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RevisionRemesasBean revisionRemesasBean = new RevisionRemesasBean();
					revisionRemesasBean.setNumeroDocumentos(resultSet.getString(1));
					return revisionRemesasBean;		
				}
			});	
			revisionRemesas= matches.size() > 0 ? (RevisionRemesasBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Número de Documentos Check List de Remesas.", e);
		}
		return revisionRemesas; 
	}
	
	// Lista de Documentos de Revisión de Remesas
	public List listaDocumentosRevisionRem(RevisionRemesasBean revisionRemesasBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CHECKLISTREMESASWSLIS(?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				revisionRemesasBean.getRemesaFolioID(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"RevisionRemesasDAO.listaDocRemesas",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHECKLISTREMESASWSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RevisionRemesasBean archivoBean = new RevisionRemesasBean();	
				archivoBean.setCheckListRemWSID(resultSet.getString("CheckListRemWSID"));
				archivoBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
				archivoBean.setDescripcion(resultSet.getString("Descripcion"));
				archivoBean.setDescripcionDoc(resultSet.getString("DescripcionDoc"));
				archivoBean.setRecurso(resultSet.getString("Recurso"));

				return archivoBean;				
			}
		});
		return matches;
	}
	
	// Lista de Archivos por Referencia para el expediente de la Revisión de Remesas en formato pdf
	public List listaArchivosReporte(RevisionRemesasBean revisionRemesasBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CHECKLISTREMESASWSLIS(?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {	
				Constantes.ENTERO_CERO,
				revisionRemesasBean.getRemesaFolioID(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"RevisionRemesasDAO.listaArchivosReporte",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CHECKLISTREMESASWSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RevisionRemesasBean revisionRemesasBean = new RevisionRemesasBean();
				revisionRemesasBean.setCheckListRemWSID(resultSet.getString("CheckListRemWSID"));
				revisionRemesasBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
				revisionRemesasBean.setDescripcion(resultSet.getString("Descripcion"));
				revisionRemesasBean.setDescripcionDoc(resultSet.getString("DescripcionDoc"));
				revisionRemesasBean.setRecurso(resultSet.getString("Recurso"));
				revisionRemesasBean.setHora(resultSet.getString("Hora"));
				revisionRemesasBean.setOrigenDoc(resultSet.getString("OrigenDoc"));
				
				return revisionRemesasBean;				
			}
		});
		return matches;
	}
}
