package seguimiento.dao;

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
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguimiento.bean.ResultadoSegtoCobranzaBean;
import seguimiento.bean.ResultadoSegtoDesProyBean;
import seguimiento.bean.SegtoArchivoBean;
import seguimiento.bean.SegtoManualBean;
import seguimiento.bean.SegtoRealizadosBean;
import seguimiento.servicio.SegtoArchivoServicio;

public class SegtoRealizadosDAO extends BaseDAO{
	private SegtoManualDAO segtoManualDAO = null;
	ResultadoSegtoCobranzaDAO resultadoSegtoCobranzaDAO = null;
	ResultadoSegtoDesProyDAO resultadoSegtoDesProyDAO = null;
	SegtoArchivoDAO segtoArchivoDAO = null;
	public SegtoRealizadosDAO(){
		super();
	}
	public static interface Enum_Num_Formulario{
		int desarrolloProy	= 2;
		int cobranzaAdmtva	= 4;
	}

	/* Alta de seguimiento Realizado */
	public MensajeTransaccionBean alta(final SegtoRealizadosBean segtoRealizadosBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							segtoRealizadosBean.setTelefonFijo(segtoRealizadosBean.getTelefonFijo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
							segtoRealizadosBean.setTelefonCel(segtoRealizadosBean.getTelefonCel().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

							String query = "call SEGTOREALIZADOSALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?, " +
										"?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_SegtoPrograID",Utileria.convierteEntero(segtoRealizadosBean.getSegtoPrograID()));
							sentenciaStore.setInt("Par_UsuarioSegto",Utileria.convierteEntero(segtoRealizadosBean.getUsuarioSegto()));
							sentenciaStore.setDate("Par_FechaSegto",OperacionesFechas.conversionStrDate(segtoRealizadosBean.getFechaSegto()));
							sentenciaStore.setString("Par_HoraCaptura",segtoRealizadosBean.getHoraCaptura());
							sentenciaStore.setString("Par_TipoContacto",segtoRealizadosBean.getTipoContacto());

							sentenciaStore.setString("Par_NombreContacto",segtoRealizadosBean.getNombreContacto());
							sentenciaStore.setString("Par_ClienteEnterado",segtoRealizadosBean.getClienteEnterado());
							sentenciaStore.setDate("Par_FechaCaptura",OperacionesFechas.conversionStrDate(segtoRealizadosBean.getFechaCaptura()));
							sentenciaStore.setString("Par_Comentario",segtoRealizadosBean.getComentario());
							sentenciaStore.setInt("Par_ResultSegtoID",Utileria.convierteEntero(segtoRealizadosBean.getResultadoSegtoID()));

							sentenciaStore.setString("Par_FechaSegtoFor",(segtoRealizadosBean.getFechaSegtoFor().equals("") ? Constantes.FECHA_VACIA : segtoRealizadosBean.getFechaSegtoFor()));
							sentenciaStore.setInt("Par_RecomSegtoID",Utileria.convierteEntero(segtoRealizadosBean.getRecomendacionSegtoID()));
							sentenciaStore.setInt("Par_SegdaRecomSegtoID",Utileria.convierteEntero(segtoRealizadosBean.getSegdaRecomendaSegtoID()));
							sentenciaStore.setString("Par_HoraSegtoFor",segtoRealizadosBean.getHoraSegtoFor());
							sentenciaStore.setString("Par_Estatus",segtoRealizadosBean.getEstatus().substring(0, 1));

							sentenciaStore.setString("Par_TelefonFijo",segtoRealizadosBean.getTelefonFijo());
							sentenciaStore.setString("Par_TelefonCel",segtoRealizadosBean.getTelefonCel());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							//Parametros de OutPut
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
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " SegtoRealizadosDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " SegtoRealizadosDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de segto programado" + e);
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

	/* Modificacion de seguimiento Realizado */
	public MensajeTransaccionBean modifica(final SegtoRealizadosBean segtoRealizadosBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							segtoRealizadosBean.setTelefonFijo(segtoRealizadosBean.getTelefonFijo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
							segtoRealizadosBean.setTelefonCel(segtoRealizadosBean.getTelefonCel().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

							String query = "call SEGTOREALIZADOSMOD( ?,?,?,?,?," +
									"?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?, ?,?,?," +
									"?,?,?,?, ?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_SegtoPrograID",Utileria.convierteEntero(segtoRealizadosBean.getSegtoPrograID()));
							sentenciaStore.setInt("Par_SegtoRealizaID",Utileria.convierteEntero(segtoRealizadosBean.getSegtoRealizaID()));
							sentenciaStore.setInt("Par_UsuarioSegto",Utileria.convierteEntero(segtoRealizadosBean.getUsuarioSegto()));
							sentenciaStore.setDate("Par_FechaSegto",OperacionesFechas.conversionStrDate(segtoRealizadosBean.getFechaSegto()));
							sentenciaStore.setString("Par_HoraCaptura",segtoRealizadosBean.getHoraCaptura());

							sentenciaStore.setString("Par_TipoContacto",segtoRealizadosBean.getTipoContacto());
							sentenciaStore.setString("Par_NombreContacto",segtoRealizadosBean.getNombreContacto());
							sentenciaStore.setString("Par_ClienteEnterado",segtoRealizadosBean.getClienteEnterado());
							sentenciaStore.setDate("Par_FechaCaptura",OperacionesFechas.conversionStrDate(segtoRealizadosBean.getFechaCaptura()));
							sentenciaStore.setString("Par_Comentario",segtoRealizadosBean.getComentario());

							sentenciaStore.setInt("Par_ResultSegtoID",Utileria.convierteEntero(segtoRealizadosBean.getResultadoSegtoID()));
							sentenciaStore.setString("Par_FechaSegtoFor",(segtoRealizadosBean.getFechaSegtoFor().equals("") ? Constantes.FECHA_VACIA : segtoRealizadosBean.getFechaSegtoFor()));
							sentenciaStore.setInt("Par_RecomSegtoID",Utileria.convierteEntero(segtoRealizadosBean.getRecomendacionSegtoID()));
							sentenciaStore.setInt("Par_SegdaRecomSegtoID",Utileria.convierteEntero(segtoRealizadosBean.getSegdaRecomendaSegtoID()));
							sentenciaStore.setString("Par_HoraSegtoFor",segtoRealizadosBean.getHoraSegtoFor());

							sentenciaStore.setString("Par_Estatus",segtoRealizadosBean.getEstatus().substring(0, 1));
							sentenciaStore.setString("Par_TelefonFijo",segtoRealizadosBean.getTelefonFijo());
							sentenciaStore.setString("Par_TelefonCel",segtoRealizadosBean.getTelefonCel());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " SegtoRealizadosDAO.modifica");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " SegtoRealizadosDAO.modifica");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la modificacion de segto programado" + e);
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

	public MensajeTransaccionBean modificaSegtoRealizado(final SegtoRealizadosBean segtoRealizadosBean, final HttpServletRequest request) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = modifica(segtoRealizadosBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					String consecutivoInt = mensajeBean.getConsecutivoInt();
					String consecutivoStr = mensajeBean.getConsecutivoString();
					String descripcion = mensajeBean.getDescripcion();
					String nombreControl = mensajeBean.getNombreControl();
					int numero = mensajeBean.getNumero();

					if (Utileria.convierteEntero(segtoRealizadosBean.getCategoriaID()) == Enum_Num_Formulario.cobranzaAdmtva){
						ResultadoSegtoCobranzaBean resultadoBean = new ResultadoSegtoCobranzaBean();
						resultadoBean.setSegtoPrograID(segtoRealizadosBean.getSegtoPrograID());
						resultadoBean.setSegtoRealizaID(segtoRealizadosBean.getSegtoRealizaID());
						resultadoBean.setFechaPromPago(request.getParameter("fechaPromPago"));
						resultadoBean.setMontoPromPago(request.getParameter("montoPromPago"));
						resultadoBean.setExistFlujo(request.getParameter("existFlujo"));
						resultadoBean.setFechaEstFlujo(request.getParameter("fechaEstFlujo"));
						resultadoBean.setOrigenPagoID(request.getParameter("origenPagoID")== "" ? Constantes.STRING_CERO : request.getParameter("origenPagoID"));
						resultadoBean.setMotivoNPID(request.getParameter("motivoNPID") == "" ? Constantes.STRING_CERO : request.getParameter("motivoNPID"));
						resultadoBean.setNomOriRecursos(request.getParameter("nomOriRecursos"));
						resultadoBean.setTelefonFijo(request.getParameter("telefonFijo"));
						resultadoBean.setTelefonCel(request.getParameter("telefonCel"));
						mensajeBean = resultadoSegtoCobranzaDAO.modifica(resultadoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}else if (Utileria.convierteEntero(segtoRealizadosBean.getCategoriaID()) == Enum_Num_Formulario.desarrolloProy){
						ResultadoSegtoDesProyBean desProyBean = new ResultadoSegtoDesProyBean();
						desProyBean.setSegtoPrograID(request.getParameter("segtoPrograID"));
						desProyBean.setSegtoRealizaID(segtoRealizadosBean.getSegtoRealizaID());
						desProyBean.setAsistenciaGpo(request.getParameter("asistenciaGpo"));
						desProyBean.setAvanceProy(request.getParameter("avanceProy"));
						desProyBean.setConoceMtosFechas(request.getParameter("recoMontoFecha"));
						desProyBean.setFechaComercializa(request.getParameter("fechaComercial"));
						desProyBean.setMontoEspVtas(request.getParameter("montoEstVtas"));
						desProyBean.setMontoEstProd(request.getParameter("montoEstProd"));
						desProyBean.setPrecioEstUni(request.getParameter("montoEstUni"));
						desProyBean.setReconoceAdeudo(request.getParameter("recoAdeudo"));
						desProyBean.setUnidEstProd(request.getParameter("uniEstProd"));
						desProyBean.setTelefonoFijo(request.getParameter("telefonFijo"));
						desProyBean.setTelefonoCel(request.getParameter("telefonCel"));
						mensajeBean = resultadoSegtoDesProyDAO.modifica(desProyBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					// Borramos todos los registros
					SegtoArchivoBean segtoArchivoBaja = new SegtoArchivoBean();
					segtoArchivoBaja.setSegtoPrograID(segtoRealizadosBean.getSegtoPrograID());
					segtoArchivoBaja.setNumSecuencia(segtoRealizadosBean.getSegtoRealizaID());
					mensajeBean = segtoArchivoDAO.bajaSegtoArchivos(segtoArchivoBaja);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					/*Se insertan los archivos Adjuntos*/
					if (segtoRealizadosBean.getFolioID() != null  && segtoRealizadosBean.getFolioID().size() > 0 ) {
						// alta de archivos
						for (int i=0; i < segtoRealizadosBean.getFolioID().size(); i++){
							SegtoArchivoBean segtoArchivoBean = new SegtoArchivoBean();
							segtoArchivoBean.setSegtoPrograID(segtoRealizadosBean.getSegtoPrograID());
							segtoArchivoBean.setConsecutivoID(consecutivoStr);
							segtoArchivoBean.setFolioID(String.valueOf(segtoRealizadosBean.getFolioID().get(i)));
							segtoArchivoBean.setRutaArchivo(String.valueOf(segtoRealizadosBean.getRutaArchivo().get(i)));
							segtoArchivoBean.setNombreArchivo(String.valueOf(segtoRealizadosBean.getNombreArchivo().get(i)));
							segtoArchivoBean.setTipoDocumentoID(String.valueOf(segtoRealizadosBean.getTipoDocID().get(i)));
							segtoArchivoBean.setComentaAdjunto(String.valueOf(segtoRealizadosBean.getComentaAdjunto().get(i)));
							mensajeBean = segtoArchivoDAO.altaSegtoArchivos(segtoArchivoBean);
							if(mensajeBean.getNumero()!=0){
								mensajeBean.setDescripcion("Error al Intentar Guardar Documentos Adjuntos");
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}


					/* Se valida si la Fecha del Seguimiento Forzado no es vacia y el estatus es Terminado o Reprogramado
					entonces se inserta un nuevo registro en la tabla de SEGTOPROGRAMADO*/
					if(Utileria.convierteFecha(segtoRealizadosBean.getFechaSegtoFor()) != Constantes.FECHA_VACIA){
						if(segtoRealizadosBean.getEstatus().equals("T") ||segtoRealizadosBean.getEstatus().equals("R") ){
							SegtoManualBean segtoManualBean = new SegtoManualBean();
							segtoManualBean.setCreditoID(request.getParameter("creditoID"));
							segtoManualBean.setGrupoID(request.getParameter("grupoID"));
							segtoManualBean.setFechaProgramada(request.getParameter("fechaSegtoFor"));
							segtoManualBean.setHoraProgramada(request.getParameter("cuentaAhoIDCa"));
							segtoManualBean.setCategoriaID(request.getParameter("categoriaID"));
							segtoManualBean.setPuestoResponsableID(request.getParameter("puestoResponsableID"));
							segtoManualBean.setPuestoSupervisorID(request.getParameter("puestoSupervisorID"));
							segtoManualBean.setTipoGeneracion(request.getParameter("tipoGeneracion"));
							segtoManualBean.setSecSegtoForzado(request.getParameter("segtoPrograID"));
							segtoManualBean.setFechaProxForzado(request.getParameter("fechaSegtoFor"));
							segtoManualBean.setEstatus("P");	// Estatus Programado
							segtoManualBean.setEsForzado("S"); 	// es forzado

							mensajeBean= segtoManualDAO.alta(segtoManualBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					mensajeBean.setNumero(numero);
					mensajeBean.setDescripcion("Seguimiento Modificado Exitosamente.");
					mensajeBean.setNombreControl("segtoRealizaID");
					mensajeBean.setConsecutivoString(consecutivoStr);
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de segto realizado " + e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*Alta de seguimiento realizado*/
	public MensajeTransaccionBean altaSegtoRealizado(final SegtoRealizadosBean segtoRealizadosBean, final HttpServletRequest request) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = alta(segtoRealizadosBean,parametrosAuditoriaBean.getNumeroTransaccion());
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					String consecutivoInt = mensajeBean.getConsecutivoInt();
					String consecutivoStr = mensajeBean.getConsecutivoString();
					String descripcion = mensajeBean.getDescripcion();
					String nombreControl = mensajeBean.getNombreControl();
					int numero = mensajeBean.getNumero();
					/* Validacion para identificar la Categoria del Seguimiento y poder insertar en el formulario correcto*/
					if (Utileria.convierteEntero(segtoRealizadosBean.getCategoriaID()) == Enum_Num_Formulario.cobranzaAdmtva){
						ResultadoSegtoCobranzaBean resultadoBean = new ResultadoSegtoCobranzaBean();
						resultadoBean.setSegtoPrograID(request.getParameter("segtoPrograID"));
						resultadoBean.setSegtoRealizaID(consecutivoStr);
						resultadoBean.setFechaPromPago(request.getParameter("fechaPromPago"));
						resultadoBean.setMontoPromPago(request.getParameter("montoPromPago"));
						resultadoBean.setExistFlujo(request.getParameter("existFlujo"));
						resultadoBean.setFechaEstFlujo(request.getParameter("fechaEstFlujo"));
						resultadoBean.setOrigenPagoID(request.getParameter("origenPagoID")== "" ? Constantes.STRING_CERO : request.getParameter("origenPagoID"));
						resultadoBean.setMotivoNPID(request.getParameter("motivoNPID") == "" ? Constantes.STRING_CERO : request.getParameter("motivoNPID"));
						resultadoBean.setNomOriRecursos(request.getParameter("nomOriRecursos"));
						resultadoBean.setTelefonFijo(request.getParameter("telefonFijo"));
						resultadoBean.setTelefonCel(request.getParameter("telefonCel"));
						mensajeBean = resultadoSegtoCobranzaDAO.alta(resultadoBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}else if (Utileria.convierteEntero(segtoRealizadosBean.getCategoriaID()) == Enum_Num_Formulario.desarrolloProy){
						ResultadoSegtoDesProyBean desProyBean = new ResultadoSegtoDesProyBean();
						desProyBean.setSegtoPrograID(request.getParameter("segtoPrograID"));
						desProyBean.setSegtoRealizaID(consecutivoStr);
						desProyBean.setAsistenciaGpo(request.getParameter("asistenciaGpo"));
						desProyBean.setAvanceProy(request.getParameter("avanceProy"));
						desProyBean.setConoceMtosFechas(request.getParameter("recoMontoFecha"));
						desProyBean.setFechaComercializa(request.getParameter("fechaComercial"));
						desProyBean.setMontoEspVtas(request.getParameter("montoEstVtas"));
						desProyBean.setMontoEstProd(request.getParameter("montoEstProd"));
						desProyBean.setPrecioEstUni(request.getParameter("montoEstUni"));
						desProyBean.setReconoceAdeudo(request.getParameter("recoAdeudo"));
						desProyBean.setUnidEstProd(request.getParameter("uniEstProd"));
						desProyBean.setTelefonoFijo(request.getParameter("telefonFijo"));
						desProyBean.setTelefonoCel(request.getParameter("telefonCel"));
						mensajeBean = resultadoSegtoDesProyDAO.alta(desProyBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					System.out.println("Consecutivo -> " + segtoRealizadosBean.getFolioID());
					if (segtoRealizadosBean.getFolioID() != null){
						/*Se insertan los archivos Adjuntos*/
						if (segtoRealizadosBean.getFolioID().size() > 0 ) {
							//alta de archivos
							for (int i=0; i < segtoRealizadosBean.getFolioID().size(); i++){
								SegtoArchivoBean segtoArchivoBean = new SegtoArchivoBean();
								segtoArchivoBean.setSegtoPrograID(segtoRealizadosBean.getSegtoPrograID());
								segtoArchivoBean.setConsecutivoID(consecutivoStr);
								segtoArchivoBean.setFolioID(String.valueOf(segtoRealizadosBean.getFolioID().get(i)));
								segtoArchivoBean.setRutaArchivo(String.valueOf(segtoRealizadosBean.getRutaArchivo().get(i)));
								segtoArchivoBean.setNombreArchivo(String.valueOf(segtoRealizadosBean.getNombreArchivo().get(i)));
								segtoArchivoBean.setTipoDocumentoID(String.valueOf(segtoRealizadosBean.getTipoDocID().get(i)));
								segtoArchivoBean.setComentaAdjunto(String.valueOf(segtoRealizadosBean.getComentaAdjunto().get(i)));
								mensajeBean = segtoArchivoDAO.altaSegtoArchivos(segtoArchivoBean);
							}
						}
						/* Se valida si la Fecha del Seguimiento Forzado no es vacia y el estatus es Terminado o Reprogramado
						entonces se inserta un nuevo registro en la tabla de SEGTOPROGRAMADO*/
						if(Utileria.convierteFecha(segtoRealizadosBean.getFechaSegtoFor()) != Constantes.FECHA_VACIA){
							if(segtoRealizadosBean.getEstatus().equals("T") ||segtoRealizadosBean.getEstatus().equals("R") ){
								SegtoManualBean segtoManualBean = new SegtoManualBean();
								segtoManualBean.setCreditoID(request.getParameter("creditoID"));
								segtoManualBean.setGrupoID(request.getParameter("grupoID"));
								segtoManualBean.setFechaProgramada(request.getParameter("fechaSegtoFor"));
								segtoManualBean.setHoraProgramada(request.getParameter("horaSegtoFor"));
								segtoManualBean.setCategoriaID(request.getParameter("categoriaID"));
								segtoManualBean.setPuestoResponsableID(request.getParameter("puestoResponsableID"));
								segtoManualBean.setPuestoSupervisorID(request.getParameter("puestoSupervisorID"));
								segtoManualBean.setTipoGeneracion(request.getParameter("tipoGeneracion"));
								segtoManualBean.setSecSegtoForzado(request.getParameter("segtoPrograID"));
								segtoManualBean.setFechaProxForzado(request.getParameter("fechaSegtoFor"));
								segtoManualBean.setEstatus("P");	// Estatus Programado
								segtoManualBean.setEsForzado("S"); 	// es forzado
								mensajeBean= segtoManualDAO.alta(segtoManualBean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}
					}

					mensajeBean.setNumero(numero);
					mensajeBean.setDescripcion("Seguimiento Realizado Exitosamente.");
					mensajeBean.setNombreControl(nombreControl);
					mensajeBean.setConsecutivoString(consecutivoStr);
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de segto realizado" + e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean eliminaSegtoRealizado(final SegtoRealizadosBean segtoRealizadosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOREALIZADOSBAJ(?,?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							segtoRealizadosBean.getSegtoPrograID(),
							segtoRealizadosBean.getSegtoRealizaID(),
							Constantes.ENTERO_CERO,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SegtoRealizadosDAO.elimina",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOREALIZADOSBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de segto realizado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consuta Creditos por Llave Principal */
	public SegtoRealizadosBean consultaPrincipal(SegtoRealizadosBean segtoRealizadosBean, int tipoConsulta) {
		SegtoRealizadosBean segtoRealizadosConsulta = new SegtoRealizadosBean();
		try{
			// Query con el Store Procedure
			String query = "call SEGTOREALIZADOSCON(" +
					"?,?,?,?,?, ?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(segtoRealizadosBean.getSegtoPrograID()),
					Utileria.convierteEntero(segtoRealizadosBean.getSegtoRealizaID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SegtoRealizadosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOREALIZADOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SegtoRealizadosBean segtoRealizadosBean = new SegtoRealizadosBean();
				    segtoRealizadosBean.setSegtoPrograID(resultSet.getString("SegtoPrograID"));
				    segtoRealizadosBean.setSegtoRealizaID(resultSet.getString("SegtoRealizaID"));
				    segtoRealizadosBean.setUsuarioSegto(resultSet.getString("UsuarioSegto"));
				    segtoRealizadosBean.setFechaSegto(resultSet.getString("FechaSegto"));
				    segtoRealizadosBean.setHoraCaptura(resultSet.getString("HoraCaptura"));

				    segtoRealizadosBean.setTipoContacto(resultSet.getString("TipoContacto"));
				    segtoRealizadosBean.setNombreContacto(resultSet.getString("NombreContacto"));
				    segtoRealizadosBean.setClienteEnterado(resultSet.getString("ClienteEnterado"));
				    segtoRealizadosBean.setFechaCaptura(resultSet.getString("FechaCaptura"));
				    segtoRealizadosBean.setComentario(resultSet.getString("Comentario"));

				    segtoRealizadosBean.setResultadoSegtoID(resultSet.getString("ResultadoSegtoID"));
				    segtoRealizadosBean.setFechaSegtoFor(resultSet.getString("FechaSegtoFor"));
				    segtoRealizadosBean.setHoraSegtoFor(resultSet.getString("HoraSegtoFor"));
				    segtoRealizadosBean.setRecomendacionSegtoID(resultSet.getString("RecomendacionSegtoID"));
				    segtoRealizadosBean.setSegdaRecomendaSegtoID(resultSet.getString("SegdaRecomendaSegtoID"));

				    segtoRealizadosBean.setEstatus(resultSet.getString("Estatus"));
				    segtoRealizadosBean.setTelefonFijo(String.valueOf(resultSet.getString("TelefonFijo")));
				    segtoRealizadosBean.setTelefonCel(String.valueOf(resultSet.getString("TelefonCel")));

				    return segtoRealizadosBean;
				}
			});
			segtoRealizadosConsulta = matches.size() > 0 ? (SegtoRealizadosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return segtoRealizadosConsulta;
	}

	/* Consuta El Estatus del ultimo Seguimiento*/
	public SegtoRealizadosBean consultaEstatus(SegtoRealizadosBean segtoRealizadosBean, int tipoConsulta) {
		SegtoRealizadosBean segtoRealizadosConsulta = new SegtoRealizadosBean();
		try{
			// Query con el Store Procedure
			String query = "call SEGTOREALIZADOSCON(" +
					"?,?,?,?,?, ?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(segtoRealizadosBean.getSegtoPrograID()),
					Utileria.convierteEntero(segtoRealizadosBean.getSegtoRealizaID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SegtoRealizadosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOREALIZADOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SegtoRealizadosBean segtoRealizadosBean = new SegtoRealizadosBean();
				    segtoRealizadosBean.setSegtoRealizaID(resultSet.getString("SegtoRealizaID"));
				    segtoRealizadosBean.setEstatus(resultSet.getString("Estatus"));

				    return segtoRealizadosBean;
				}
			});
			segtoRealizadosConsulta = matches.size() > 0 ? (SegtoRealizadosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return segtoRealizadosConsulta;
	}


	public List listaPrincipal(final SegtoRealizadosBean segtoRealizadosBean, int tipoLista) {
		List listaResultado = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTOREALIZADOSLIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(segtoRealizadosBean.getSegtoPrograID()),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SegtoRecomendasDAO.listaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOREALIZADOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SegtoRealizadosBean segtoRecomendasBean = new SegtoRealizadosBean();
					segtoRecomendasBean.setSegtoRealizaID(resultSet.getString("SegtoRealizaID"));
					segtoRecomendasBean.setFechaCaptura(resultSet.getString("FechaCaptura"));
					segtoRecomendasBean.setComentario(resultSet.getString("Comentario"));
					return segtoRecomendasBean;
				}
			});
			listaResultado =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista SEGTORECOMENDASLIS: " +e);
		}
		return listaResultado;
	}

	public SegtoManualDAO getSegtoManualDAO() {
		return segtoManualDAO;
	}
	public void setSegtoManualDAO(SegtoManualDAO segtoManualDAO) {
		this.segtoManualDAO = segtoManualDAO;
	}
	public ResultadoSegtoCobranzaDAO getResultadoSegtoCobranzaDAO() {
		return resultadoSegtoCobranzaDAO;
	}
	public void setResultadoSegtoCobranzaDAO(
			ResultadoSegtoCobranzaDAO resultadoSegtoCobranzaDAO) {
		this.resultadoSegtoCobranzaDAO = resultadoSegtoCobranzaDAO;
	}
	public ResultadoSegtoDesProyDAO getResultadoSegtoDesProyDAO() {
		return resultadoSegtoDesProyDAO;
	}
	public void setResultadoSegtoDesProyDAO(
			ResultadoSegtoDesProyDAO resultadoSegtoDesProyDAO) {
		this.resultadoSegtoDesProyDAO = resultadoSegtoDesProyDAO;
	}
	public SegtoArchivoDAO getSegtoArchivoDAO() {
		return segtoArchivoDAO;
	}
	public void setSegtoArchivoDAO(SegtoArchivoDAO segtoArchivoDAO) {
		this.segtoArchivoDAO = segtoArchivoDAO;
	}
}
