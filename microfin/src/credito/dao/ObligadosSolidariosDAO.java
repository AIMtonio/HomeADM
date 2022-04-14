package credito.dao;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import credito.bean.ObligadosSolidariosBean;

public class ObligadosSolidariosDAO extends BaseDAO{

	java.sql.Date fecha = null;
	public ParametrosSesionBean parametrosSesionBean = null;
	public ObligadosSolidariosDAO() {
		super();
	}

	// Alta de nuevo Obligado Solidario
	public MensajeTransaccionBean altaObligadoSolidario(final ObligadosSolidariosBean obligadosSolidariosBean) {
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
								obligadosSolidariosBean.setTelefono(obligadosSolidariosBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								obligadosSolidariosBean.setTelefonoCel(obligadosSolidariosBean.getTelefonoCel().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								obligadosSolidariosBean.setTelefonoTrabajo(obligadosSolidariosBean.getTelefonoTrabajo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								String query = "call OBLSOLIDALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,?, ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_PrimerNom",obligadosSolidariosBean.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNom",obligadosSolidariosBean.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNom",obligadosSolidariosBean.getTercerNombre());
								sentenciaStore.setString("Par_ApellidoPat",obligadosSolidariosBean.getApellidoPaterno());
								sentenciaStore.setString("Par_ApellidoMat",obligadosSolidariosBean.getApellidoMaterno());

								sentenciaStore.setString("Par_Telefono",obligadosSolidariosBean.getTelefono());
								sentenciaStore.setString("Par_Calle",obligadosSolidariosBean.getCalle());
								sentenciaStore.setString("Par_NumExterior",obligadosSolidariosBean.getNumExterior());
								sentenciaStore.setString("Par_NumInterior",obligadosSolidariosBean.getNumInterior());
								sentenciaStore.setString("Par_Manzana",obligadosSolidariosBean.getManzana());

								sentenciaStore.setString("Par_Lote",obligadosSolidariosBean.getLote());
								sentenciaStore.setString("Par_Colonia",obligadosSolidariosBean.getColonia());
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(obligadosSolidariosBean.getColoniaID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(obligadosSolidariosBean.getLocalidadID()));
								sentenciaStore.setString("Par_MunicipioID",obligadosSolidariosBean.getMunicipioID());

								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(obligadosSolidariosBean.getEstadoID()));
								sentenciaStore.setInt("Par_CP",Utileria.convierteEntero(obligadosSolidariosBean.getcP()));
								sentenciaStore.setString("Par_TipoPersona",obligadosSolidariosBean.getTipoPersona());
								sentenciaStore.setString("Par_RazonSocial",obligadosSolidariosBean.getRazonSocial());
								sentenciaStore.setString("Par_RFC",obligadosSolidariosBean.getrFC());

								sentenciaStore.setString("Par_Latitud",obligadosSolidariosBean.getLatitud());
								sentenciaStore.setString("Par_Longitud",obligadosSolidariosBean.getLongitud());
								sentenciaStore.setDate("Par_FechaNac",OperacionesFechas.conversionStrDate(obligadosSolidariosBean.getFechaNac()));
								sentenciaStore.setString("Par_TelefonoCel",obligadosSolidariosBean.getTelefonoCel());
								sentenciaStore.setString("Par_RFCpm",obligadosSolidariosBean.getrFCpm());

								sentenciaStore.setString("Par_Sexo",obligadosSolidariosBean.getSexo());
								sentenciaStore.setString("Par_EstadoCivil",obligadosSolidariosBean.getEstadoCivil());
								sentenciaStore.setString("Par_ExtTelefonoPart",obligadosSolidariosBean.getExtTelefonoPart());
								sentenciaStore.setString("Par_Esc_Tipo",obligadosSolidariosBean.getEsc_Tipo());
								sentenciaStore.setString("Par_NomApoder",obligadosSolidariosBean.getNomApoderado());

								sentenciaStore.setString("Par_RFC_Apoder",obligadosSolidariosBean.getRFC_Apoderado());
								sentenciaStore.setString("Par_EscriPub",obligadosSolidariosBean.getEscrituraPub());
								sentenciaStore.setString("Par_LibroEscr",obligadosSolidariosBean.getLibroEscritura());
								sentenciaStore.setString("Par_VolumenEsc",obligadosSolidariosBean.getVolumenEsc());
								sentenciaStore.setString("Par_FechaEsc", Utileria.convierteFecha(obligadosSolidariosBean.getFechaEsc()));

								sentenciaStore.setInt("Par_EstadoIDEsc",Utileria.convierteEntero(obligadosSolidariosBean.getEstadoIDEsc()));
								sentenciaStore.setInt("Par_LocalEsc",Utileria.convierteEntero(obligadosSolidariosBean.getLocalidadEsc()));
								sentenciaStore.setInt("Par_Notaria",Utileria.convierteEntero(obligadosSolidariosBean.getNotaria()));
								sentenciaStore.setString("Par_DirecNotar",obligadosSolidariosBean.getDirecNotaria());
								sentenciaStore.setString("Par_NomNotario",obligadosSolidariosBean.getNomNotario());

								sentenciaStore.setString("Par_RegistroPub",obligadosSolidariosBean.getRegistroPub());
								sentenciaStore.setString("Par_FolioRegPub",obligadosSolidariosBean.getFolioRegPub());
								sentenciaStore.setString("Par_VolRegPub",obligadosSolidariosBean.getVolumenRegPub());
								sentenciaStore.setString("Par_LibroRegPub",obligadosSolidariosBean.getLibroRegPub());
								sentenciaStore.setString("Par_AuxiRegPub",obligadosSolidariosBean.getAuxiliarRegPub());

								sentenciaStore.setString("Par_FechaRegPub", Utileria.convierteFecha(obligadosSolidariosBean.getFechaRegPub()));
								sentenciaStore.setInt("Par_EstadoIDReg",Utileria.convierteEntero(obligadosSolidariosBean.getEstadoIDReg()));
								sentenciaStore.setInt("Par_LocalRegPub",Utileria.convierteEntero(obligadosSolidariosBean.getLocalidadRegPub()));
								sentenciaStore.setString("Par_Nacion",obligadosSolidariosBean.getNacion());
								sentenciaStore.setInt("Par_LugarNacimiento", Utileria.convierteEntero(obligadosSolidariosBean.getLugarNacimiento()));

								sentenciaStore.setInt("Par_OcupacionID", Utileria.convierteEntero(obligadosSolidariosBean.getOcupacionID()));
								sentenciaStore.setString("Par_Puesto", obligadosSolidariosBean.getPuesto());
								sentenciaStore.setString("Par_DomicilioTrabajo", obligadosSolidariosBean.getDomicilioTrabajo());
								sentenciaStore.setString("Par_TelefonoTrabajo", obligadosSolidariosBean.getTelefonoTrabajo());
								sentenciaStore.setString("Par_ExtTelTrabajo", obligadosSolidariosBean.getExtTelTrabajo());

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Obligados Solidarios: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de obligados Solidarios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Modificacion de obligado Solidario
	public MensajeTransaccionBean modificacionObligadoSOlidario(final ObligadosSolidariosBean obligadosSolidariosBean) {
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
								obligadosSolidariosBean.setTelefono(obligadosSolidariosBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								obligadosSolidariosBean.setTelefonoCel(obligadosSolidariosBean.getTelefonoCel().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								obligadosSolidariosBean.setTelefonoTrabajo(obligadosSolidariosBean.getTelefonoTrabajo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

								String query = "call OBLSOLIDMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_OblSolidID",Utileria.convierteEntero(obligadosSolidariosBean.getOblSolidarioID()));
								sentenciaStore.setString("Par_PrimerNom",obligadosSolidariosBean.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNom",obligadosSolidariosBean.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNom",obligadosSolidariosBean.getTercerNombre());
								sentenciaStore.setString("Par_ApellidoPat",obligadosSolidariosBean.getApellidoPaterno());

								sentenciaStore.setString("Par_ApellidoMat",obligadosSolidariosBean.getApellidoMaterno());
								sentenciaStore.setString("Par_Telefono",obligadosSolidariosBean.getTelefono());
								sentenciaStore.setString("Par_Calle",obligadosSolidariosBean.getCalle());
								sentenciaStore.setString("Par_NumExterior",obligadosSolidariosBean.getNumExterior());
								sentenciaStore.setString("Par_NumInterior",obligadosSolidariosBean.getNumInterior());

								sentenciaStore.setString("Par_Manzana",obligadosSolidariosBean.getManzana());
								sentenciaStore.setString("Par_Lote",obligadosSolidariosBean.getLote());
								sentenciaStore.setString("Par_Colonia",obligadosSolidariosBean.getColonia());
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(obligadosSolidariosBean.getColoniaID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(obligadosSolidariosBean.getLocalidadID()));

								sentenciaStore.setString("Par_MunicipioID",obligadosSolidariosBean.getMunicipioID());
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(obligadosSolidariosBean.getEstadoID()));
								sentenciaStore.setInt("Par_CP",Utileria.convierteEntero(obligadosSolidariosBean.getcP()));
								sentenciaStore.setString("Par_TipoPersona",obligadosSolidariosBean.getTipoPersona());
								sentenciaStore.setString("Par_RazonSocial",obligadosSolidariosBean.getRazonSocial());

								sentenciaStore.setString("Par_RFC",obligadosSolidariosBean.getrFC());
								sentenciaStore.setString("Par_Latitud",obligadosSolidariosBean.getLatitud());
								sentenciaStore.setString("Par_Longitud",obligadosSolidariosBean.getLongitud());
								sentenciaStore.setDate("Par_FechaNac",OperacionesFechas.conversionStrDate(obligadosSolidariosBean.getFechaNac()));
								sentenciaStore.setString("Par_TelefonoCel",obligadosSolidariosBean.getTelefonoCel());

								sentenciaStore.setString("Par_RFCpm",obligadosSolidariosBean.getrFCpm());
								sentenciaStore.setString("Par_Sexo",obligadosSolidariosBean.getSexo());
								sentenciaStore.setString("Par_EstadoCivil",obligadosSolidariosBean.getEstadoCivil());
								sentenciaStore.setString("Par_ExtTelefonoPart",obligadosSolidariosBean.getExtTelefonoPart());
								sentenciaStore.setString("Par_Esc_Tipo",obligadosSolidariosBean.getEsc_Tipo());

								sentenciaStore.setString("Par_NomApoder",obligadosSolidariosBean.getNomApoderado());
								sentenciaStore.setString("Par_RFC_Apoder",obligadosSolidariosBean.getRFC_Apoderado());
								sentenciaStore.setString("Par_EscriPub",obligadosSolidariosBean.getEscrituraPub());
								sentenciaStore.setString("Par_LibroEscr",obligadosSolidariosBean.getLibroEscritura());
								sentenciaStore.setString("Par_VolumenEsc",obligadosSolidariosBean.getVolumenEsc());

								sentenciaStore.setString("Par_FechaEsc", Utileria.convierteFecha(obligadosSolidariosBean.getFechaEsc()));
								sentenciaStore.setInt("Par_EstadoIDEsc",Utileria.convierteEntero(obligadosSolidariosBean.getEstadoIDEsc()));
								sentenciaStore.setInt("Par_LocalEsc",Utileria.convierteEntero(obligadosSolidariosBean.getLocalidadEsc()));
								sentenciaStore.setInt("Par_Notaria",Utileria.convierteEntero(obligadosSolidariosBean.getNotaria()));
								sentenciaStore.setString("Par_DirecNotar",obligadosSolidariosBean.getDirecNotaria());

								sentenciaStore.setString("Par_NomNotario",obligadosSolidariosBean.getNomNotario());
								sentenciaStore.setString("Par_RegistroPub",obligadosSolidariosBean.getRegistroPub());
								sentenciaStore.setString("Par_FolioRegPub",obligadosSolidariosBean.getFolioRegPub());
								sentenciaStore.setString("Par_VolRegPub",obligadosSolidariosBean.getVolumenRegPub());
								sentenciaStore.setString("Par_LibroRegPub",obligadosSolidariosBean.getLibroRegPub());

								sentenciaStore.setString("Par_AuxiRegPub",obligadosSolidariosBean.getAuxiliarRegPub());
								sentenciaStore.setString("Par_FechaRegPub", Utileria.convierteFecha(obligadosSolidariosBean.getFechaRegPub()));
								sentenciaStore.setInt("Par_EstadoIDReg",Utileria.convierteEntero(obligadosSolidariosBean.getEstadoIDReg()));
								sentenciaStore.setInt("Par_LocalRegPub",Utileria.convierteEntero(obligadosSolidariosBean.getLocalidadRegPub()));
								sentenciaStore.setString("Par_Nacion",obligadosSolidariosBean.getNacion());

								sentenciaStore.setInt("Par_LugarNacimiento", Utileria.convierteEntero(obligadosSolidariosBean.getLugarNacimiento()));

								sentenciaStore.setInt("Par_OcupacionID", Utileria.convierteEntero(obligadosSolidariosBean.getOcupacionID()));
								sentenciaStore.setString("Par_Puesto", obligadosSolidariosBean.getPuesto());
								sentenciaStore.setString("Par_DomicilioTrabajo", obligadosSolidariosBean.getDomicilioTrabajo());
								sentenciaStore.setString("Par_TelefonoTrabajo", obligadosSolidariosBean.getTelefonoTrabajo());
								sentenciaStore.setString("Par_ExtTelTrabajo", obligadosSolidariosBean.getExtTelTrabajo());

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Obligado Solidario: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de Obligado Solidario", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//Consulta principal de obligado solidario
	public ObligadosSolidariosBean consultaPrincipal(ObligadosSolidariosBean obligadosSolidariosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call OBLSOLIDCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { obligadosSolidariosBean.getOblSolidarioID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				ObligadosSolidariosBean obligadosSolidariosBean = new ObligadosSolidariosBean();
				obligadosSolidariosBean.setOblSolidarioID(String.valueOf(resultSet.getLong("OblSolidID")));
				obligadosSolidariosBean.setTipoPersona(resultSet.getString("TipoPersona"));
				obligadosSolidariosBean.setRazonSocial(resultSet.getString("RazonSocial"));
				obligadosSolidariosBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
				obligadosSolidariosBean.setSegundoNombre(resultSet.getString("SegundoNombre"));
				obligadosSolidariosBean.setTercerNombre(resultSet.getString("TercerNombre"));

				obligadosSolidariosBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				obligadosSolidariosBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				obligadosSolidariosBean.setrFC(resultSet.getString("RFC"));
				obligadosSolidariosBean.setTelefono(resultSet.getString("Telefono"));
				obligadosSolidariosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));

				obligadosSolidariosBean.setCalle(resultSet.getString("Calle"));
				obligadosSolidariosBean.setNumExterior(resultSet.getString("NumExterior"));
				obligadosSolidariosBean.setNumInterior(resultSet.getString("NumInterior"));
				obligadosSolidariosBean.setManzana(resultSet.getString("Manzana"));
				obligadosSolidariosBean.setLote(resultSet.getString("Lote"));

				obligadosSolidariosBean.setColonia(resultSet.getString("Colonia"));
				obligadosSolidariosBean.setColoniaID(String.valueOf(resultSet.getInt("ColoniaID")));
				obligadosSolidariosBean.setLocalidadID(String.valueOf(resultSet.getInt("LocalidadID")));
				obligadosSolidariosBean.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
				obligadosSolidariosBean.setEstadoID(String.valueOf(resultSet.getInt("EstadoID")));

				obligadosSolidariosBean.setcP(resultSet.getString("CP"));
				obligadosSolidariosBean.setLatitud(resultSet.getString("Latitud"));
				obligadosSolidariosBean.setLongitud(resultSet.getString("Longitud"));
				obligadosSolidariosBean.setFechaNac(resultSet.getString("FechaNac"));
				obligadosSolidariosBean.setTelefonoCel(resultSet.getString("TelefonoCel"));
				obligadosSolidariosBean.setrFCpm(resultSet.getString("RFCpm"));
				obligadosSolidariosBean.setSexo(resultSet.getString("Sexo"));
				obligadosSolidariosBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				obligadosSolidariosBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				obligadosSolidariosBean.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));

				obligadosSolidariosBean.setEsc_Tipo(resultSet.getString("Esc_Tipo"));
				obligadosSolidariosBean.setEscrituraPub(resultSet.getString("EscrituraPublic"));
				obligadosSolidariosBean.setLibroEscritura(resultSet.getString("LibroEscritura"));
				obligadosSolidariosBean.setVolumenEsc(resultSet.getString("VolumenEsc"));
				obligadosSolidariosBean.setFechaEsc(resultSet.getString("FechaEsc"));
				obligadosSolidariosBean.setEstadoIDEsc(String.valueOf(resultSet.getInt("EstadoIDEsc")));
				obligadosSolidariosBean.setLocalidadEsc(String.valueOf(resultSet.getInt("LocalidadEsc")));
				obligadosSolidariosBean.setNotaria(String.valueOf(resultSet.getInt("Notaria")));
				obligadosSolidariosBean.setDirecNotaria(resultSet.getString("DirecNotaria"));
				obligadosSolidariosBean.setNomNotario(resultSet.getString("NomNotario"));
				obligadosSolidariosBean.setNomApoderado(resultSet.getString("NomApoderado"));
				obligadosSolidariosBean.setRFC_Apoderado(resultSet.getString("RFC_Apoderado"));
				obligadosSolidariosBean.setRegistroPub(resultSet.getString("RegistroPub"));
				obligadosSolidariosBean.setFolioRegPub(resultSet.getString("FolioRegPub"));
				obligadosSolidariosBean.setVolumenRegPub(resultSet.getString("VolumenRegPub"));
				obligadosSolidariosBean.setLibroRegPub(resultSet.getString("LibroRegPub"));
				obligadosSolidariosBean.setAuxiliarRegPub(resultSet.getString("AuxiliarRegPub"));
				obligadosSolidariosBean.setFechaRegPub(resultSet.getString("FechaRegPub"));
				obligadosSolidariosBean.setEstadoIDReg(String.valueOf(resultSet.getInt("EstadoIDReg")));
				obligadosSolidariosBean.setLocalidadRegPub(String.valueOf(resultSet.getInt("LocalidadRegPub")));
				obligadosSolidariosBean.setNacion(resultSet.getString("Nacion"));
				obligadosSolidariosBean.setLugarNacimiento(resultSet.getString("LugarNacimiento"));

				obligadosSolidariosBean.setOcupacionID(resultSet.getString("OcupacionID"));
				obligadosSolidariosBean.setOcupacion(resultSet.getString("Descripcion"));
				obligadosSolidariosBean.setPuesto(resultSet.getString("Puesto"));
				obligadosSolidariosBean.setDomicilioTrabajo(resultSet.getString("DomicilioTrabajo"));
				obligadosSolidariosBean.setTelefonoTrabajo(resultSet.getString("TelefonoTrabajo"));
				obligadosSolidariosBean.setExtTelTrabajo(resultSet.getString("ExtTelTrabajo"));
				return obligadosSolidariosBean;
			}
		});
		return matches.size() > 0 ? (ObligadosSolidariosBean) matches.get(0) : null;
	}

	//Consulta Creditos obligados solidarios
	//*************************************************************************OK
		public ObligadosSolidariosBean consultaCreditosOblSolidarios(ObligadosSolidariosBean obligadosSolidariosBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call OBLSOLIDCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { obligadosSolidariosBean.getOblSolidarioID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ObligadosSolidariosBean obligadosSolidariosBean = new ObligadosSolidariosBean();

					obligadosSolidariosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					obligadosSolidariosBean.setCreditosAvalados(resultSet.getString("CreditosAvalados"));
					obligadosSolidariosBean.setEstatusCliente(resultSet.getString("EstatusCliente"));
					obligadosSolidariosBean.setOblSolidarioID(String.valueOf(resultSet.getLong("OblSolidID")));
					obligadosSolidariosBean.setClienteID(resultSet.getString("ClienteID"));
					obligadosSolidariosBean.setProspectoID(resultSet.getString("ProspectoID"));
					return obligadosSolidariosBean;
				}
			});
			return matches.size() > 0 ? (ObligadosSolidariosBean) matches.get(0) : null;
		}
		//*********************************************************************OK




	public List listaAlfanumerica(ObligadosSolidariosBean obligadosSolidariosBean, int tipoLista){
		String query = "call OBLSOLIDLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

				obligadosSolidariosBean.getNombreCompleto(),
				obligadosSolidariosBean.getClienteID()==null?0:obligadosSolidariosBean.getClienteID(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"obligadosSolidariosDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ObligadosSolidariosBean obligadosSolidariosBean = new ObligadosSolidariosBean();
				obligadosSolidariosBean.setOblSolidarioID(resultSet.getString("OblSolidID"));
				obligadosSolidariosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return obligadosSolidariosBean;

			}
		});
		return matches;
		}
	// Lista para Grid de creditos a los que esta relacionados una persona como aval(Requerimiento Seido)
	public List listaCreditos(ObligadosSolidariosBean obligadosSolidariosBean, int tipoLista){
		String query = "call OBLSOLIDLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

				obligadosSolidariosBean.getNombreCompleto(),
				obligadosSolidariosBean.getClienteID()==null?0:obligadosSolidariosBean.getClienteID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"obligadosSolidariosDAO.listaCreditos",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ObligadosSolidariosBean obligadosSolidariosBean = new ObligadosSolidariosBean();
				obligadosSolidariosBean.setClienteID(resultSet.getString("ClienteID"));
				obligadosSolidariosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				obligadosSolidariosBean.setCreditoID(resultSet.getString("CreditoID"));
				obligadosSolidariosBean.setMontoCredito(resultSet.getString("MontoCredito"));
				obligadosSolidariosBean.setFechaNac(resultSet.getString("FechaNacimiento"));
				obligadosSolidariosBean.setrFC(resultSet.getString("RFC"));
				obligadosSolidariosBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				return obligadosSolidariosBean;

			}
		});
		return matches;
		}

	public List listaObligadosSolidariosxCliente(ObligadosSolidariosBean obligadosSolidariosBean, int tipoLista){
		String query = "call OBLSOLIDLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				obligadosSolidariosBean.getNombreCompleto(),
				obligadosSolidariosBean.getClienteID()==null?0:obligadosSolidariosBean.getClienteID(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"obligadosSolidariosDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDESLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ObligadosSolidariosBean obligadosSolidariosBean = new ObligadosSolidariosBean();
				obligadosSolidariosBean.setOblSolidarioID(resultSet.getString(1));
				obligadosSolidariosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				obligadosSolidariosBean.setClienteID(resultSet.getString("ClienteID"));
				obligadosSolidariosBean.setSucursal(resultSet.getString("SucursalID"));
				obligadosSolidariosBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				obligadosSolidariosBean.setTelefono(resultSet.getString("Telefono"));
				obligadosSolidariosBean.setTelefonoCel(resultSet.getString("TelefonoCel"));
				obligadosSolidariosBean.setCreditoID(resultSet.getString("CreditoID"));
				obligadosSolidariosBean.setEstatus(resultSet.getString("Estatus"));
				return obligadosSolidariosBean;
			}
		});
		return matches;
		}

	/* Lista de obligados solidarios asignados a una Solicitud de Credito */
	public List listaObligadosSolidariosSol(ObligadosSolidariosBean obligadosSolidariosBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call OBLSOLIDSOLICITUDLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	obligadosSolidariosBean.getNombreCompleto(),
								obligadosSolidariosBean.getCreditoID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OBLSOLIDSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ObligadosSolidariosBean obligadosSolidariosBean = new ObligadosSolidariosBean();
				obligadosSolidariosBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				obligadosSolidariosBean.setOblSolidarioID(resultSet.getString("OblSolidID"));
				obligadosSolidariosBean.setClienteID(resultSet.getString("ClienteID"));
				obligadosSolidariosBean.setProspectoID(resultSet.getString("ProspectoID"));
				obligadosSolidariosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return obligadosSolidariosBean;
			}
		});
		return matches;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}