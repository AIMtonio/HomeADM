package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.dao.DocumentosGuardaValoresDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.CambioPuestoIntegrantesBean;

import cliente.bean.CheckListRegistroBean;

public class CheckListRegistroDAO extends BaseDAO{

	public CheckListRegistroDAO() {
		super();
	}
	ParametrosSesionBean parametrosSesionBean;
	DocumentosGuardaValoresDAO documentosGuardaValoresDAO = null;
	private final static String salidaPantalla = "S";
	// ------------------ Transacciones ------------------------------------------

	/* Alta del check */
	public MensajeTransaccionBean altaChekListRegistro(final CheckListRegistroBean check) {
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
									String query = "call CHECLISTACT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Instrumento",Utileria.convierteEntero(check.getInstrumento()));
									sentenciaStore.setInt("Par_TipoInstrumentoID",Utileria.convierteEntero(check.getTipoInstrumento()));
									sentenciaStore.setInt("Par_GrupoDocumentoID",Utileria.convierteEntero(check.getGrupoDocumentoID()));
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(check.getTipoDocumentoID()));
									sentenciaStore.setString("Par_Comentario",check.getComentarios());
									sentenciaStore.setString("Par_Aceptado",check.getDocAceptado());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
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
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCheckListRegistro");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Captura de Check List de Registro" + e);
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

	/* metodo Para actualizacion de check list*/
	public MensajeTransaccionBean metodoAltaCheck(final CheckListRegistroBean checkBean,final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				final String tipoCliente = "C";
				int numeroError = 0;
				String descripcion = "";
				String nombreControl = "";
				String consecutivo = "";
				try {
					CheckListRegistroBean bean;
					if(listaBean!=null){



						for(int i=0; i<listaBean.size(); i++){

							/* obtenemos un bean de la lista */
							bean = (CheckListRegistroBean)listaBean.get(i);
							bean.setInstrumento(checkBean.getInstrumento());
							bean.setTipoInstrumento(checkBean.getTipoInstrumento());
							mensajeBean = altaChekListRegistro(bean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Ingresar notificacion en esta seccion

						}

						numeroError = mensajeBean.getNumero();
						descripcion = mensajeBean.getDescripcion();
						nombreControl = mensajeBean.getNombreControl();
						consecutivo = mensajeBean.getConsecutivoString();

						DocumentosGuardaValoresBean documentosGuardaValoresBean = new DocumentosGuardaValoresBean();
						documentosGuardaValoresBean.setTipoInstrumento(checkBean.getInstrumento());
						documentosGuardaValoresBean.setTipoPersona(tipoCliente);
						mensajeBean = documentosGuardaValoresDAO.notificacionCorreo(documentosGuardaValoresBean);

						mensajeBean.setNumero(numeroError);
						mensajeBean.setDescripcion(descripcion);
						mensajeBean.setNombreControl(nombreControl);
						mensajeBean.setConsecutivoString(consecutivo);

					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Check List Registro", e);
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

	}// fin de modificar

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public DocumentosGuardaValoresDAO getDocumentosGuardaValoresDAO() {
		return documentosGuardaValoresDAO;
	}

	public void setDocumentosGuardaValoresDAO(
			DocumentosGuardaValoresDAO documentosGuardaValoresDAO) {
		this.documentosGuardaValoresDAO = documentosGuardaValoresDAO;
	}

}
