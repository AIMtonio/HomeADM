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

import credito.bean.AvalesBean;

public class AvalesDAO extends BaseDAO{

	java.sql.Date fecha = null;
	public ParametrosSesionBean parametrosSesionBean = null;
	public AvalesDAO() {
		super();
	}

	// Alta de nuevo Aval
	public MensajeTransaccionBean altaAval(final AvalesBean avalesBean) {
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
								avalesBean.setTelefono(avalesBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								avalesBean.setTelefonoCel(avalesBean.getTelefonoCel().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								String query = "call AVALESALT(?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?,	?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_PrimerNom",avalesBean.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNom",avalesBean.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNom",avalesBean.getTercerNombre());
								sentenciaStore.setString("Par_ApellidoPat",avalesBean.getApellidoPaterno());
								sentenciaStore.setString("Par_ApellidoMat",avalesBean.getApellidoMaterno());

								sentenciaStore.setString("Par_Telefono",avalesBean.getTelefono());
								sentenciaStore.setString("Par_Calle",avalesBean.getCalle());
								sentenciaStore.setString("Par_NumExterior",avalesBean.getNumExterior());
								sentenciaStore.setString("Par_NumInterior",avalesBean.getNumInterior());
								sentenciaStore.setString("Par_Manzana",avalesBean.getManzana());

								sentenciaStore.setString("Par_Lote",avalesBean.getLote());
								sentenciaStore.setString("Par_Colonia",avalesBean.getColonia());
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(avalesBean.getColoniaID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(avalesBean.getLocalidadID()));
								sentenciaStore.setString("Par_MunicipioID",avalesBean.getMunicipioID());

								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(avalesBean.getEstadoID()));
								sentenciaStore.setInt("Par_CP",Utileria.convierteEntero(avalesBean.getcP()));
								sentenciaStore.setString("Par_TipoPersona",avalesBean.getTipoPersona());
								sentenciaStore.setString("Par_RazonSocial",avalesBean.getRazonSocial());
								sentenciaStore.setString("Par_RFC",avalesBean.getrFC());

								sentenciaStore.setString("Par_Latitud",avalesBean.getLatitud());
								sentenciaStore.setString("Par_Longitud",avalesBean.getLongitud());
								sentenciaStore.setDate("Par_FechaNac",OperacionesFechas.conversionStrDate(avalesBean.getFechaNac()));
								sentenciaStore.setString("Par_TelefonoCel",avalesBean.getTelefonoCel());
								sentenciaStore.setString("Par_RFCpm",avalesBean.getrFCpm());

								sentenciaStore.setString("Par_Sexo",avalesBean.getSexo());
								sentenciaStore.setString("Par_EstadoCivil",avalesBean.getEstadoCivil());
								sentenciaStore.setString("Par_ExtTelefonoPart",avalesBean.getExtTelefonoPart());
								sentenciaStore.setString("Par_Esc_Tipo",avalesBean.getesc_Tipo());
								sentenciaStore.setString("Par_NomApoder",avalesBean.getnomApoderado());

								sentenciaStore.setString("Par_RFC_Apoder",avalesBean.getRFC_Apoderado());
								sentenciaStore.setString("Par_EscriPub",avalesBean.getescrituraPub());
								sentenciaStore.setString("Par_LibroEscr",avalesBean.getlibroEscritura());
								sentenciaStore.setString("Par_VolumenEsc",avalesBean.getvolumenEsc());
								sentenciaStore.setString("Par_FechaEsc", Utileria.convierteFecha(avalesBean.getfechaEsc()));

								sentenciaStore.setInt("Par_EstadoIDEsc",Utileria.convierteEntero(avalesBean.getestadoIDEsc()));
								sentenciaStore.setInt("Par_LocalEsc",Utileria.convierteEntero(avalesBean.getlocalidadEsc()));
								sentenciaStore.setInt("Par_Notaria",Utileria.convierteEntero(avalesBean.getnotaria()));
								sentenciaStore.setString("Par_DirecNotar",avalesBean.getdirecNotaria());
								sentenciaStore.setString("Par_NomNotario",avalesBean.getnomNotario());

								sentenciaStore.setString("Par_RegistroPub",avalesBean.getregistroPub());
								sentenciaStore.setString("Par_FolioRegPub",avalesBean.getfolioRegPub());
								sentenciaStore.setString("Par_VolRegPub",avalesBean.getvolumenRegPub());
								sentenciaStore.setString("Par_LibroRegPub",avalesBean.getlibroRegPub());
								sentenciaStore.setString("Par_AuxiRegPub",avalesBean.getauxiliarRegPub());

								sentenciaStore.setString("Par_FechaRegPub", Utileria.convierteFecha(avalesBean.getfechaRegPub()));
								sentenciaStore.setInt("Par_EstadoIDReg",Utileria.convierteEntero(avalesBean.getestadoIDReg()));
								sentenciaStore.setInt("Par_LocalRegPub",Utileria.convierteEntero(avalesBean.getlocalidadRegPub()));
								sentenciaStore.setString("Par_Nacion",avalesBean.getNacion());
								sentenciaStore.setInt("Par_LugarNacimiento", Utileria.convierteEntero(avalesBean.getLugarNacimiento()));

								sentenciaStore.setInt("Par_OcupacionID", Utileria.convierteEntero(avalesBean.getOcupacionID()));
								sentenciaStore.setString("Par_Puesto", avalesBean.getPuesto());
								sentenciaStore.setString("Par_DomicilioTrabajo", avalesBean.getDomicilioTrabajo());
								sentenciaStore.setString("Par_TelefonoTrabajo", avalesBean.getTelefonoTrabajo());
								sentenciaStore.setString("Par_ExtTelTrabajo", avalesBean.getExtTelTrabajo());

								sentenciaStore.setString("Par_NumIdentificacion", avalesBean.getNumIdentific());
								sentenciaStore.setString("Par_FechaExpIdentif",Utileria.convierteFecha(avalesBean.getFecExIden()));
								sentenciaStore.setString("Par_FechaVencIdentif", Utileria.convierteFecha(avalesBean.getFecVenIden()));


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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Aval: " + mensajeBean.getDescripcion());
							mensajeBean.setDescripcion("No es posible realizar la operación, la persona hizo coincidencia con la Listas de Personas Bloqueadas");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de avales", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Modificacion de aval
	public MensajeTransaccionBean modificacionAval(final AvalesBean avalesBean) {
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
								avalesBean.setTelefono(avalesBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								avalesBean.setTelefonoCel(avalesBean.getTelefonoCel().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								String query = "call AVALESMOD(?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?,?, " +
																"?,?,?,?,?, ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_AvalID",Utileria.convierteEntero(avalesBean.getAvalID()));
								sentenciaStore.setString("Par_PrimerNom",avalesBean.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNom",avalesBean.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNom",avalesBean.getTercerNombre());
								sentenciaStore.setString("Par_ApellidoPat",avalesBean.getApellidoPaterno());

								sentenciaStore.setString("Par_ApellidoMat",avalesBean.getApellidoMaterno());
								sentenciaStore.setString("Par_Telefono",avalesBean.getTelefono());
								sentenciaStore.setString("Par_Calle",avalesBean.getCalle());
								sentenciaStore.setString("Par_NumExterior",avalesBean.getNumExterior());
								sentenciaStore.setString("Par_NumInterior",avalesBean.getNumInterior());

								sentenciaStore.setString("Par_Manzana",avalesBean.getManzana());
								sentenciaStore.setString("Par_Lote",avalesBean.getLote());
								sentenciaStore.setString("Par_Colonia",avalesBean.getColonia());
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(avalesBean.getColoniaID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(avalesBean.getLocalidadID()));

								sentenciaStore.setString("Par_MunicipioID",avalesBean.getMunicipioID());
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(avalesBean.getEstadoID()));
								sentenciaStore.setInt("Par_CP",Utileria.convierteEntero(avalesBean.getcP()));
								sentenciaStore.setString("Par_TipoPersona",avalesBean.getTipoPersona());
								sentenciaStore.setString("Par_RazonSocial",avalesBean.getRazonSocial());

								sentenciaStore.setString("Par_RFC",avalesBean.getrFC());
								sentenciaStore.setString("Par_Latitud",avalesBean.getLatitud());
								sentenciaStore.setString("Par_Longitud",avalesBean.getLongitud());
								sentenciaStore.setDate("Par_FechaNac",OperacionesFechas.conversionStrDate(avalesBean.getFechaNac()));
								sentenciaStore.setString("Par_TelefonoCel",avalesBean.getTelefonoCel());

								sentenciaStore.setString("Par_RFCpm",avalesBean.getrFCpm());
								sentenciaStore.setString("Par_Sexo",avalesBean.getSexo());
								sentenciaStore.setString("Par_EstadoCivil",avalesBean.getEstadoCivil());
								sentenciaStore.setString("Par_ExtTelefonoPart",avalesBean.getExtTelefonoPart());
								sentenciaStore.setString("Par_Esc_Tipo",avalesBean.getesc_Tipo());

								sentenciaStore.setString("Par_NomApoder",avalesBean.getnomApoderado());
								sentenciaStore.setString("Par_RFC_Apoder",avalesBean.getRFC_Apoderado());
								sentenciaStore.setString("Par_EscriPub",avalesBean.getescrituraPub());
								sentenciaStore.setString("Par_LibroEscr",avalesBean.getlibroEscritura());
								sentenciaStore.setString("Par_VolumenEsc",avalesBean.getvolumenEsc());

								sentenciaStore.setString("Par_FechaEsc", Utileria.convierteFecha(avalesBean.getfechaEsc()));
								sentenciaStore.setInt("Par_EstadoIDEsc",Utileria.convierteEntero(avalesBean.getestadoIDEsc()));
								sentenciaStore.setInt("Par_LocalEsc",Utileria.convierteEntero(avalesBean.getlocalidadEsc()));
								sentenciaStore.setInt("Par_Notaria",Utileria.convierteEntero(avalesBean.getnotaria()));
								sentenciaStore.setString("Par_DirecNotar",avalesBean.getdirecNotaria());

								sentenciaStore.setString("Par_NomNotario",avalesBean.getnomNotario());
								sentenciaStore.setString("Par_RegistroPub",avalesBean.getregistroPub());
								sentenciaStore.setString("Par_FolioRegPub",avalesBean.getfolioRegPub());
								sentenciaStore.setString("Par_VolRegPub",avalesBean.getvolumenRegPub());
								sentenciaStore.setString("Par_LibroRegPub",avalesBean.getlibroRegPub());

								sentenciaStore.setString("Par_AuxiRegPub",avalesBean.getauxiliarRegPub());
								sentenciaStore.setString("Par_FechaRegPub", Utileria.convierteFecha(avalesBean.getfechaRegPub()));
								sentenciaStore.setInt("Par_EstadoIDReg",Utileria.convierteEntero(avalesBean.getestadoIDReg()));
								sentenciaStore.setInt("Par_LocalRegPub",Utileria.convierteEntero(avalesBean.getlocalidadRegPub()));
								sentenciaStore.setString("Par_Nacion",avalesBean.getNacion());

								sentenciaStore.setInt("Par_LugarNacimiento", Utileria.convierteEntero(avalesBean.getLugarNacimiento()));

								sentenciaStore.setInt("Par_OcupacionID", Utileria.convierteEntero(avalesBean.getOcupacionID()));
								sentenciaStore.setString("Par_Puesto", avalesBean.getPuesto());
								sentenciaStore.setString("Par_DomicilioTrabajo", avalesBean.getDomicilioTrabajo());
								sentenciaStore.setString("Par_TelefonoTrabajo", avalesBean.getTelefonoTrabajo());
								sentenciaStore.setString("Par_ExtTelTrabajo", avalesBean.getExtTelTrabajo());

								sentenciaStore.setString("Par_NumIdentificacion", avalesBean.getNumIdentific());
								sentenciaStore.setString("Par_FechaExpIdentif",Utileria.convierteFecha(avalesBean.getFecExIden()));
								sentenciaStore.setString("Par_FechaVencIdentif", Utileria.convierteFecha(avalesBean.getFecVenIden()));

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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Aval: " + mensajeBean.getDescripcion());
							mensajeBean.setDescripcion("No es posible realizar la operación, la persona hizo coincidencia con la Listas de Personas Bloqueadas");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de avales", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//Consulta principal de aval
	public AvalesBean consultaPrincipal(AvalesBean avalesBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call AVALESCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { avalesBean.getAvalID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AvalesBean avalesBean = new AvalesBean();
				avalesBean.setAvalID(String.valueOf(resultSet.getLong("AvalID")));
				avalesBean.setTipoPersona(resultSet.getString("TipoPersona"));
				avalesBean.setRazonSocial(resultSet.getString("RazonSocial"));
				avalesBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
				avalesBean.setSegundoNombre(resultSet.getString("SegundoNombre"));
				avalesBean.setTercerNombre(resultSet.getString("TercerNombre"));

				avalesBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				avalesBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				avalesBean.setrFC(resultSet.getString("RFC"));
				avalesBean.setTelefono(resultSet.getString("Telefono"));
				avalesBean.setNombreCompleto(resultSet.getString("NombreCompleto"));

				avalesBean.setCalle(resultSet.getString("Calle"));
				avalesBean.setNumExterior(resultSet.getString("NumExterior"));
				avalesBean.setNumInterior(resultSet.getString("NumInterior"));
				avalesBean.setManzana(resultSet.getString("Manzana"));
				avalesBean.setLote(resultSet.getString("Lote"));

				avalesBean.setColonia(resultSet.getString("Colonia"));
				avalesBean.setColoniaID(String.valueOf(resultSet.getInt("ColoniaID")));
				avalesBean.setLocalidadID(String.valueOf(resultSet.getInt("LocalidadID")));
				avalesBean.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
				avalesBean.setEstadoID(String.valueOf(resultSet.getInt("EstadoID")));

				avalesBean.setcP(resultSet.getString("CP"));
				avalesBean.setLatitud(resultSet.getString("Latitud"));
				avalesBean.setLongitud(resultSet.getString("Longitud"));
				avalesBean.setFechaNac(resultSet.getString("FechaNac"));
				avalesBean.setTelefonoCel(resultSet.getString("TelefonoCel"));
				avalesBean.setrFCpm(resultSet.getString("RFCpm"));
				avalesBean.setSexo(resultSet.getString("Sexo"));
				avalesBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				avalesBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				avalesBean.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));

				avalesBean.setesc_Tipo(resultSet.getString("Esc_Tipo"));
				avalesBean.setescrituraPub(resultSet.getString("EscrituraPublic"));
				avalesBean.setlibroEscritura(resultSet.getString("LibroEscritura"));
				avalesBean.setvolumenEsc(resultSet.getString("VolumenEsc"));
				avalesBean.setfechaEsc(resultSet.getString("FechaEsc"));
				avalesBean.setestadoIDEsc(String.valueOf(resultSet.getInt("EstadoIDEsc")));
				avalesBean.setlocalidadEsc(String.valueOf(resultSet.getInt("LocalidadEsc")));
				avalesBean.setnotaria(String.valueOf(resultSet.getInt("Notaria")));
				avalesBean.setdirecNotaria(resultSet.getString("DirecNotaria"));
				avalesBean.setnomNotario(resultSet.getString("NomNotario"));
				avalesBean.setnomApoderado(resultSet.getString("NomApoderado"));
				avalesBean.setRFC_Apoderado(resultSet.getString("RFC_Apoderado"));
				avalesBean.setregistroPub(resultSet.getString("RegistroPub"));
				avalesBean.setfolioRegPub(resultSet.getString("FolioRegPub"));
				avalesBean.setvolumenRegPub(resultSet.getString("VolumenRegPub"));
				avalesBean.setlibroRegPub(resultSet.getString("LibroRegPub"));
				avalesBean.setauxiliarRegPub(resultSet.getString("AuxiliarRegPub"));
				avalesBean.setfechaRegPub(resultSet.getString("FechaRegPub"));
				avalesBean.setestadoIDReg(String.valueOf(resultSet.getInt("EstadoIDReg")));
				avalesBean.setlocalidadRegPub(String.valueOf(resultSet.getInt("LocalidadRegPub")));
				avalesBean.setNacion(resultSet.getString("Nacion"));
				avalesBean.setLugarNacimiento(resultSet.getString("LugarNacimiento"));

				avalesBean.setOcupacionID(resultSet.getString("OcupacionID"));
				avalesBean.setOcupacion(resultSet.getString("Descripcion"));
				avalesBean.setPuesto(resultSet.getString("Puesto"));
				avalesBean.setDomicilioTrabajo(resultSet.getString("DomicilioTrabajo"));
				avalesBean.setTelefonoTrabajo(resultSet.getString("TelefonoTrabajo"));
				avalesBean.setExtTelTrabajo(resultSet.getString("ExtTelTrabajo"));

				avalesBean.setNumIdentific(resultSet.getString("NumIdentific"));
				avalesBean.setFecExIden(resultSet.getString("FecExIden"));
				avalesBean.setFecVenIden(resultSet.getString("FecVenIden"));

				return avalesBean;
			}
		});
		return matches.size() > 0 ? (AvalesBean) matches.get(0) : null;
	}

	//Consulta Creditos Avalados
	//*************************************************************************OK
		public AvalesBean consultaCreditosAvalados(AvalesBean avalesBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call AVALESCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { avalesBean.getAvalID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AvalesBean avalesBean = new AvalesBean();

					avalesBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					avalesBean.setCreditosAvalados(resultSet.getString("CreditosAvalados"));
					avalesBean.setEstatusCliente(resultSet.getString("EstatusCliente"));
					avalesBean.setAvalID(String.valueOf(resultSet.getLong("AvalID")));
					avalesBean.setClienteID(resultSet.getString("ClienteID"));
					avalesBean.setProspectoID(resultSet.getString("ProspectoID"));
					return avalesBean;
				}
			});
			return matches.size() > 0 ? (AvalesBean) matches.get(0) : null;
		}
		//*********************************************************************OK


		//Consulta Avales que son Persona Fisica o Fisica con Actividad Empresarial
			public AvalesBean consultaAvalesPersonaFisica(AvalesBean avalesBean, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call AVALESCON(?,? ,?,?,?,?,?,?,?);";
				Object[] parametros = { avalesBean.getAvalID(),
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										Constantes.STRING_VACIO,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESCON(  " + Arrays.toString(parametros) + ")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						AvalesBean avalesBean = new AvalesBean();

						avalesBean.setAvalID(String.valueOf(resultSet.getLong("AvalID")));
						avalesBean.setNombreCompleto(resultSet.getString("NombreCompleto"));

						return avalesBean;
					}
				});
				return matches.size() > 0 ? (AvalesBean) matches.get(0) : null;
			}



	public List listaAlfanumerica(AvalesBean avalesBean, int tipoLista){
		String query = "call AVALESLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

				avalesBean.getNombreCompleto(),
				avalesBean.getClienteID()==null?0:avalesBean.getClienteID(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"avalesDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AvalesBean avales = new AvalesBean();
				avales.setAvalID(resultSet.getString("AvalID"));
				avales.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return avales;

			}
		});
		return matches;
		}
	// Lista para Grid de creditos a los que esta relacionados una persona como aval(Requerimiento Seido)
	public List listaCreditos(AvalesBean avalesBean, int tipoLista){
		String query = "call AVALESLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

				avalesBean.getNombreCompleto(),
				avalesBean.getClienteID()==null?0:avalesBean.getClienteID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"avalesDAO.listaCreditos",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AvalesBean avales = new AvalesBean();
				avales.setClienteID(resultSet.getString("ClienteID"));
				avales.setNombreCompleto(resultSet.getString("NombreCompleto"));
				avales.setCreditoID(resultSet.getString("CreditoID"));
				avales.setMontoCredito(resultSet.getString("MontoCredito"));
				avales.setFechaNac(resultSet.getString("FechaNacimiento"));
				avales.setrFC(resultSet.getString("RFC"));
				avales.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				return avales;

			}
		});
		return matches;
		}

	public List listaAvalesxCliente(AvalesBean avalesBean, int tipoLista){
		String query = "call AVALESLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				avalesBean.getNombreCompleto(),
				avalesBean.getClienteID()==null?0:avalesBean.getClienteID(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"avalesDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AvalesBean avales = new AvalesBean();
				avales.setAvalID(resultSet.getString(1));
				avales.setNombreCompleto(resultSet.getString("NombreCompleto"));
				avales.setClienteID(resultSet.getString("ClienteID"));
				avales.setSucursal(resultSet.getString("SucursalID"));
				avales.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				avales.setTelefono(resultSet.getString("Telefono"));
				avales.setTelefonoCel(resultSet.getString("TelefonoCel"));
				avales.setCreditoID(resultSet.getString("CreditoID"));
				avales.setEstatus(resultSet.getString("Estatus"));
				return avales;
			}
		});
		return matches;
		}

	/* Lista de Avales asignados a una Solicitud de Credito */
	public List listaAvalesSol(AvalesBean avalesBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call AVALESSOLICITUDLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	avalesBean.getNombreCompleto(),
								avalesBean.getCreditoID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AvalesBean avales = new AvalesBean();
				avales.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				avales.setAvalID(resultSet.getString("AvalID"));
				avales.setClienteID(resultSet.getString("ClienteID"));
				avales.setProspectoID(resultSet.getString("ProspectoID"));
				avales.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return avales;
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