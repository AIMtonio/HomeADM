package cliente.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cuentas.bean.CuentasAhoBean;
import cuentas.bean.CuentasPersonaBean;
import cliente.bean.AdicionalPersonaMoralBean;

public class AdicionalPersonaMoralDAO extends BaseDAO {

	ParametrosSesionBean	parametrosSesionBean;
	public AdicionalPersonaMoralDAO() {
		super();
	}

	// Realiza la asignacion de un limite de operacion a un cliente
	public MensajeTransaccionBean altaAdicionalPersonaMoral(final AdicionalPersonaMoralBean adicionalPersonaMoralBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DIRECTIVOSALT(	   ?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,       ?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_ClienteID", Utileria.convierteLong(adicionalPersonaMoralBean.getNumCliente()));
							sentenciaStore.setString("Par_DirectivoID", adicionalPersonaMoralBean.getDirectivoID());
							sentenciaStore.setLong("Par_RelacionadoID", Utileria.convierteLong(adicionalPersonaMoralBean.getNumeroCte()));
							sentenciaStore.setLong("Par_GaranteID", Utileria.convierteLong(adicionalPersonaMoralBean.getGaranteID()));
							sentenciaStore.setLong("Par_AvalID", Utileria.convierteLong(adicionalPersonaMoralBean.getAvalID()));

							sentenciaStore.setLong("Par_GaranteRelacion", Utileria.convierteLong(adicionalPersonaMoralBean.getGaranteRelacion()));
							sentenciaStore.setLong("Par_AvalRelacion", Utileria.convierteLong(adicionalPersonaMoralBean.getAvalRelacion()));
							sentenciaStore.setString("Par_CargoID", adicionalPersonaMoralBean.getCargoID());
							sentenciaStore.setString("Par_EsApoderado", adicionalPersonaMoralBean.getEsApoderado());
							sentenciaStore.setString("Par_ConsejoAdmon", adicionalPersonaMoralBean.getConsejoAdmon());

							sentenciaStore.setString("Par_EsAccionista", adicionalPersonaMoralBean.getEsAccionista());
							sentenciaStore.setString("Par_Titulo", adicionalPersonaMoralBean.getTitulo());
							sentenciaStore.setString("Par_PrimerNom", adicionalPersonaMoralBean.getPrimerNombre());
							sentenciaStore.setString("Par_SegundoNom", adicionalPersonaMoralBean.getSegundoNombre());
							sentenciaStore.setString("Par_TercerNom", adicionalPersonaMoralBean.getTercerNombre());

							sentenciaStore.setString("Par_ApellidoPat", adicionalPersonaMoralBean.getApellidoPaterno());
							sentenciaStore.setString("Par_ApellidoMat", adicionalPersonaMoralBean.getApellidoMaterno());
							sentenciaStore.setDate("Par_FechaNac", herramientas.OperacionesFechas.conversionStrDate(adicionalPersonaMoralBean.getFechaNacimiento()));
							sentenciaStore.setInt("Par_PaisNac", Utileria.convierteEntero(adicionalPersonaMoralBean.getPaisNacimiento()));
							sentenciaStore.setInt("Par_EdoNac", Utileria.convierteEntero(adicionalPersonaMoralBean.getEdoNacimiento()));

							sentenciaStore.setString("Par_EdoCivil", adicionalPersonaMoralBean.getEstadoCivil());
							sentenciaStore.setString("Par_Sexo", adicionalPersonaMoralBean.getSexo());
							sentenciaStore.setString("Par_Nacion", adicionalPersonaMoralBean.getNacion());
							sentenciaStore.setString("Par_CURP", adicionalPersonaMoralBean.getCURP());
							sentenciaStore.setString("Par_RFC", adicionalPersonaMoralBean.getRFC());

							sentenciaStore.setInt("Par_OcupacionID", Utileria.convierteEntero(adicionalPersonaMoralBean.getOcupacionID()));
							sentenciaStore.setString("Par_FEA", adicionalPersonaMoralBean.getFEA());
							sentenciaStore.setInt("Par_PaisFEA", Utileria.convierteEntero(adicionalPersonaMoralBean.getPaisFea()));
							sentenciaStore.setInt("Par_PaisRFC", Utileria.convierteEntero(adicionalPersonaMoralBean.getPaisRFC()));
							sentenciaStore.setString("Par_PuestoA", adicionalPersonaMoralBean.getPuestoA());

							sentenciaStore.setInt("Par_SectorGral", Utileria.convierteEntero(adicionalPersonaMoralBean.getSectorGeneral()));
							sentenciaStore.setString("Par_ActBancoMX", adicionalPersonaMoralBean.getActividadBancoMX());
							sentenciaStore.setInt("Par_ActINEGI", Utileria.convierteEntero(adicionalPersonaMoralBean.getActividadINEGI()));
							sentenciaStore.setInt("Par_SecEcono", Utileria.convierteEntero(adicionalPersonaMoralBean.getSectorEconomico()));
							sentenciaStore.setInt("Par_TipoIdentiID", Utileria.convierteEntero(adicionalPersonaMoralBean.getTipoIdentiID()));

							sentenciaStore.setString("Par_OtraIden", adicionalPersonaMoralBean.getOtraIdentifi());
							sentenciaStore.setString("Par_NumIden", adicionalPersonaMoralBean.getNumIdentific());
							sentenciaStore.setString("Par_FecExIden", Utileria.convierteFecha(adicionalPersonaMoralBean.getFecExIden()));
							sentenciaStore.setString("Par_FecVenIden", Utileria.convierteFecha(adicionalPersonaMoralBean.getFecVenIden()));
							sentenciaStore.setString("Par_Domicilio", adicionalPersonaMoralBean.getDomicilio());

							sentenciaStore.setString("Par_TelCasa", adicionalPersonaMoralBean.getTelefonoCasa());
							sentenciaStore.setString("Par_TelCel", adicionalPersonaMoralBean.getTelefonoCelular());
							sentenciaStore.setString("Par_Correo", adicionalPersonaMoralBean.getCorreo());
							sentenciaStore.setInt("Par_PaisRes", Utileria.convierteEntero(adicionalPersonaMoralBean.getPaisResidencia()));
							sentenciaStore.setString("Par_DocEstLegal", adicionalPersonaMoralBean.getDocEstanciaLegal());

							sentenciaStore.setString("Par_DocExisLegal", adicionalPersonaMoralBean.getDocExisLegal());
							sentenciaStore.setString("Par_FechaVenEst", Utileria.convierteFecha(adicionalPersonaMoralBean.getFechaVenEst()));
							sentenciaStore.setString("Par_NumEscPub", adicionalPersonaMoralBean.getNumEscPub());
							sentenciaStore.setString("Par_FechaEscPub", Utileria.convierteFecha(adicionalPersonaMoralBean.getFechaEscPub()));
							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(adicionalPersonaMoralBean.getEstadoID()));

							sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(adicionalPersonaMoralBean.getMunicipioID()));
							sentenciaStore.setInt("Par_NotariaID", Utileria.convierteEntero(adicionalPersonaMoralBean.getNotariaID()));
							sentenciaStore.setString("Par_TitularNotaria", adicionalPersonaMoralBean.getTitularNotaria());
							sentenciaStore.setString("Par_Fax", adicionalPersonaMoralBean.getFax());
							sentenciaStore.setString("Par_ExtTelefonoPart", adicionalPersonaMoralBean.getExtTelefonoPart());

							sentenciaStore.setDouble("Par_IngreRealoRecur", Utileria.convierteDoble(adicionalPersonaMoralBean.getIngreRealoRecursos()));
							sentenciaStore.setDouble("Par_PorcentajeAcc", Utileria.convierteDoble(adicionalPersonaMoralBean.getPorcentajeAccion()));
							sentenciaStore.setString("Par_EsPropietarioReal", adicionalPersonaMoralBean.getEsPropReal());
							sentenciaStore.setDouble("Par_ValorAcciones", Utileria.convierteDoble(adicionalPersonaMoralBean.getValorAcciones()));
							sentenciaStore.setString("Par_FolioMercantil", adicionalPersonaMoralBean.getFolioMercantil());

							sentenciaStore.setString("Par_TipoAccionista", adicionalPersonaMoralBean.getTipoAccionista());
							sentenciaStore.setString("Par_NombreCompania", adicionalPersonaMoralBean.getCompania());
							sentenciaStore.setString("Par_Direccion1", adicionalPersonaMoralBean.getDireccion1());
							sentenciaStore.setString("Par_Direccion2", adicionalPersonaMoralBean.getDireccion2());
							sentenciaStore.setInt("Par_MunNacimiento", Utileria.convierteEntero(adicionalPersonaMoralBean.getMunNacimiento()));

							sentenciaStore.setInt("Par_LocNacimiento", Utileria.convierteEntero(adicionalPersonaMoralBean.getLocNacimiento()));
							sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(adicionalPersonaMoralBean.getColoniaID()));
							sentenciaStore.setString("Par_NombreCiudad", adicionalPersonaMoralBean.getNombreCiudad());
							sentenciaStore.setString("Par_CodigoPostal", adicionalPersonaMoralBean.getCodigoPostal());
							sentenciaStore.setString("Par_EdoExtranjero", adicionalPersonaMoralBean.getEdoExtranjero());

							sentenciaStore.setString("Par_EsSolicitante", adicionalPersonaMoralBean.getEsSolicitante());
							sentenciaStore.setString("Par_EsAutorizador", adicionalPersonaMoralBean.getEsAutorizador());
							sentenciaStore.setString("Par_EsAdministrador", adicionalPersonaMoralBean.getEsAdministrador());
							sentenciaStore.setString("Par_PaisIDDom", adicionalPersonaMoralBean.getPaisIDDom());
							sentenciaStore.setString("Par_EstadoIDDom", adicionalPersonaMoralBean.getEstadoIDDom());

							sentenciaStore.setString("Par_MunicipioIDDom", adicionalPersonaMoralBean.getMunicipioIDDom());
							sentenciaStore.setString("Par_LocalidadIDDom", adicionalPersonaMoralBean.getLocalidadIDDom());
							sentenciaStore.setString("Par_ColoniaIDDom", adicionalPersonaMoralBean.getColoniaIDDom());
							sentenciaStore.setString("Par_NombreColoniaDom", adicionalPersonaMoralBean.getNombreColoniaDom());
							sentenciaStore.setString("Par_NombreCiudadDom", adicionalPersonaMoralBean.getNombreCiudadDom());

							sentenciaStore.setString("Par_CalleDom", adicionalPersonaMoralBean.getCalleDom());
							sentenciaStore.setString("Par_NumExteriorDom", adicionalPersonaMoralBean.getNumExteriorDom());
							sentenciaStore.setString("Par_NumInteriorDom", adicionalPersonaMoralBean.getNumInteriorDom());
							sentenciaStore.setString("Par_PisoDom", adicionalPersonaMoralBean.getPisoDom());
							sentenciaStore.setString("Par_PrimeraEntreDom", adicionalPersonaMoralBean.getPrimeraEntreDom());

							sentenciaStore.setString("Par_SegundaEntreDom", adicionalPersonaMoralBean.getSegundaEntreDom());
							sentenciaStore.setString("Par_CodigoPostalDom", adicionalPersonaMoralBean.getCodigoPostalDom());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {

								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
								mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if (mensajeBean.getNumero() == 50) { // Error que corresponde cuando se detecta en lista de personas bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Relacionado a la Cuenta: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de cuentas de personal: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Modificacion de los limites de operaciones de Clientes
	public MensajeTransaccionBean modificaAdicionalPersonaMoral(final AdicionalPersonaMoralBean adicionalPersonaMoralBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "rawtypes", "unchecked" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DIRECTIVOSMOD(	   ?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"

																+ "?,?,?,?,?,       ?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?,?,?,?,"
																+ "?,?,?,?,?,		?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_ClienteID", Utileria.convierteLong(adicionalPersonaMoralBean.getNumCliente()));
							sentenciaStore.setString("Par_DirectivoID", adicionalPersonaMoralBean.getDirectivoID());
							sentenciaStore.setLong("Par_RelacionadoID", Utileria.convierteLong(adicionalPersonaMoralBean.getNumeroCte()));
							sentenciaStore.setLong("Par_GaranteID", Utileria.convierteLong(adicionalPersonaMoralBean.getGaranteID()));
							sentenciaStore.setLong("Par_AvalID", Utileria.convierteLong(adicionalPersonaMoralBean.getAvalID()));
							sentenciaStore.setLong("Par_GaranteRelacion", Utileria.convierteLong(adicionalPersonaMoralBean.getGaranteRelacion()));
							sentenciaStore.setLong("Par_AvalRelacion", Utileria.convierteLong(adicionalPersonaMoralBean.getAvalRelacion()));

							sentenciaStore.setInt("Par_CargoID", Utileria.convierteEntero(adicionalPersonaMoralBean.getCargoID()));
							sentenciaStore.setString("Par_EsApoderado",adicionalPersonaMoralBean.getEsApoderado());
							sentenciaStore.setString("Par_ConsejoAdmon", adicionalPersonaMoralBean.getConsejoAdmon());
							sentenciaStore.setString("Par_EsAccionista",adicionalPersonaMoralBean.getEsAccionista());
							sentenciaStore.setString("Par_Titulo",adicionalPersonaMoralBean.getTitulo()	);
							sentenciaStore.setString("Par_PrimerNom",adicionalPersonaMoralBean.getPrimerNombre());
							sentenciaStore.setString("Par_SegundoNom",adicionalPersonaMoralBean.getSegundoNombre());
							sentenciaStore.setString("Par_TercerNom",adicionalPersonaMoralBean.getTercerNombre());

							sentenciaStore.setString("Par_ApellidoPat", adicionalPersonaMoralBean.getApellidoPaterno() );
							sentenciaStore.setString("Par_ApellidoMat", adicionalPersonaMoralBean.getApellidoMaterno());
							sentenciaStore.setString("Par_FechaNac",Utileria.convierteFecha(adicionalPersonaMoralBean.getFechaNacimiento()));
							sentenciaStore.setInt("Par_PaisNac", Utileria.convierteEntero(adicionalPersonaMoralBean.getPaisNacimiento()));
							sentenciaStore.setInt("Par_EdoNac", Utileria.convierteEntero(adicionalPersonaMoralBean.getEdoNacimiento()));

							sentenciaStore.setString("Par_EdoCivil", adicionalPersonaMoralBean.getEstadoCivil()	);
							sentenciaStore.setString("Par_Sexo",adicionalPersonaMoralBean.getSexo()	);
							sentenciaStore.setString("Par_Nacion",adicionalPersonaMoralBean.getNacion() );
							sentenciaStore.setString("Par_CURP",adicionalPersonaMoralBean.getCURP() );
							sentenciaStore.setString("Par_RFC",adicionalPersonaMoralBean.getRFC());

							sentenciaStore.setInt("Par_OcupacionID",  Utileria.convierteEntero(adicionalPersonaMoralBean.getOcupacionID()));
							sentenciaStore.setString("Par_FEA",adicionalPersonaMoralBean.getFEA());
							sentenciaStore.setInt("Par_PaisFEA",Utileria.convierteEntero(adicionalPersonaMoralBean.getPaisFea()));
							sentenciaStore.setInt("Par_PaisRFC",  Utileria.convierteEntero(adicionalPersonaMoralBean.getPaisRFC()));
							sentenciaStore.setString("Par_PuestoA", adicionalPersonaMoralBean.getPuestoA() 	);

							sentenciaStore.setInt("Par_SectorGral",Utileria.convierteEntero(adicionalPersonaMoralBean.getSectorGeneral()));
							sentenciaStore.setString("Par_ActBancoMX", adicionalPersonaMoralBean.getActividadBancoMX());
							sentenciaStore.setInt("Par_ActINEGI", Utileria.convierteEntero(adicionalPersonaMoralBean.getActividadINEGI()	) );
							sentenciaStore.setInt("Par_SecEcono", Utileria.convierteEntero(adicionalPersonaMoralBean.getSectorEconomico()	 ));
							sentenciaStore.setInt("Par_TipoIdentiID",	Utileria.convierteEntero(adicionalPersonaMoralBean.getTipoIdentiID()) );

							sentenciaStore.setString("Par_OtraIden",adicionalPersonaMoralBean.getOtraIdentifi());
							sentenciaStore.setString("Par_NumIden",	adicionalPersonaMoralBean.getNumIdentific());
							sentenciaStore.setString("Par_FecExIden",Utileria.convierteFecha(adicionalPersonaMoralBean.getFecExIden()));
							sentenciaStore.setString("Par_FecVenIden",Utileria.convierteFecha(adicionalPersonaMoralBean.getFecVenIden()));
							sentenciaStore.setString("Par_Domicilio", adicionalPersonaMoralBean.getDomicilio());

							sentenciaStore.setString("Par_TelCasa", adicionalPersonaMoralBean.getTelefonoCasa());
							sentenciaStore.setString("Par_TelCel",adicionalPersonaMoralBean.getTelefonoCelular());
							sentenciaStore.setString("Par_Correo",adicionalPersonaMoralBean.getCorreo());
							sentenciaStore.setInt("Par_PaisRes",Utileria.convierteEntero(adicionalPersonaMoralBean.getPaisResidencia())); // No estaba
							sentenciaStore.setString("Par_DocEstLegal",adicionalPersonaMoralBean.getDocEstanciaLegal());

							sentenciaStore.setString("Par_DocExisLegal",adicionalPersonaMoralBean.getDocExisLegal());
							sentenciaStore.setString("Par_FechaVenEst",Utileria.convierteFecha(adicionalPersonaMoralBean.getFechaVenEst()));
							sentenciaStore.setString("Par_NumEscPub",adicionalPersonaMoralBean.getNumEscPub());
							sentenciaStore.setString("Par_FechaEscPub", Utileria.convierteFecha(adicionalPersonaMoralBean.getFechaEscPub()));
							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(adicionalPersonaMoralBean.getEstadoID())	);

							sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(adicionalPersonaMoralBean.getMunicipioID()));
							sentenciaStore.setInt("Par_NotariaID",Utileria.convierteEntero(adicionalPersonaMoralBean.getNotariaID()));
							sentenciaStore.setString("Par_TitularNotaria",adicionalPersonaMoralBean.getTitularNotaria() );
							sentenciaStore.setString("Par_Fax",	adicionalPersonaMoralBean.getFax()  );
							sentenciaStore.setString("Par_ExtTelefonoPart", adicionalPersonaMoralBean.getExtTelefonoPart());

							sentenciaStore.setDouble("Par_IngreRealoRecur",Utileria.convierteDoble(adicionalPersonaMoralBean.getIngreRealoRecursos()));
							sentenciaStore.setDouble("Par_PorcentajeAcc",	Utileria.convierteDoble(adicionalPersonaMoralBean.getPorcentajeAccion()));
							sentenciaStore.setString("Par_EsPropietarioReal", adicionalPersonaMoralBean.getEsPropReal());
							sentenciaStore.setDouble("Par_ValorAcciones", Utileria.convierteDoble(adicionalPersonaMoralBean.getValorAcciones()));
							sentenciaStore.setString("Par_FolioMercantil", adicionalPersonaMoralBean.getFolioMercantil());

							sentenciaStore.setString("Par_TipoAccionista", adicionalPersonaMoralBean.getTipoAccionista());
							sentenciaStore.setString("Par_NombreCompania", adicionalPersonaMoralBean.getCompania());
							sentenciaStore.setString("Par_Direccion1", adicionalPersonaMoralBean.getDireccion1());
							sentenciaStore.setString("Par_Direccion2", adicionalPersonaMoralBean.getDireccion2());
							sentenciaStore.setInt("Par_MunNacimiento", Utileria.convierteEntero(adicionalPersonaMoralBean.getMunNacimiento()));

							sentenciaStore.setInt("Par_LocNacimiento", Utileria.convierteEntero(adicionalPersonaMoralBean.getLocNacimiento()));
							sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(adicionalPersonaMoralBean.getColoniaID()));
							sentenciaStore.setString("Par_NombreCiudad", adicionalPersonaMoralBean.getNombreCiudad());
							sentenciaStore.setString("Par_CodigoPostal", adicionalPersonaMoralBean.getCodigoPostal());
							sentenciaStore.setString("Par_EdoExtranjero", adicionalPersonaMoralBean.getEdoExtranjero());

							sentenciaStore.setString("Par_EsSolicitante", adicionalPersonaMoralBean.getEsSolicitante());
							sentenciaStore.setString("Par_EsAutorizador", adicionalPersonaMoralBean.getEsAutorizador());
							sentenciaStore.setString("Par_EsAdministrador", adicionalPersonaMoralBean.getEsAdministrador());
							sentenciaStore.setString("Par_PaisIDDom", adicionalPersonaMoralBean.getPaisIDDom());
							sentenciaStore.setString("Par_EstadoIDDom", adicionalPersonaMoralBean.getEstadoIDDom());

							sentenciaStore.setString("Par_MunicipioIDDom", adicionalPersonaMoralBean.getMunicipioIDDom());
							sentenciaStore.setString("Par_LocalidadIDDom", adicionalPersonaMoralBean.getLocalidadIDDom());
							sentenciaStore.setString("Par_ColoniaIDDom", adicionalPersonaMoralBean.getColoniaIDDom());
							sentenciaStore.setString("Par_NombreColoniaDom", adicionalPersonaMoralBean.getNombreColoniaDom());
							sentenciaStore.setString("Par_NombreCiudadDom", adicionalPersonaMoralBean.getNombreCiudadDom());

							sentenciaStore.setString("Par_CalleDom", adicionalPersonaMoralBean.getCalleDom());
							sentenciaStore.setString("Par_NumExteriorDom", adicionalPersonaMoralBean.getNumExteriorDom());
							sentenciaStore.setString("Par_NumInteriorDom", adicionalPersonaMoralBean.getNumInteriorDom());
							sentenciaStore.setString("Par_PisoDom", adicionalPersonaMoralBean.getPisoDom());
							sentenciaStore.setString("Par_PrimeraEntreDom", adicionalPersonaMoralBean.getPrimeraEntreDom());

							sentenciaStore.setString("Par_SegundaEntreDom", adicionalPersonaMoralBean.getSegundaEntreDom());
							sentenciaStore.setString("Par_CodigoPostalDom", adicionalPersonaMoralBean.getCodigoPostalDom());

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
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente: " + mensajeBean.getDescripcion());
								mensajeBean.setDescripcion("No es posible realizar la operación, el prospecto hizo coincidencia con la Listas de Personas Bloqueadas");
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Modificacion de Información Adicional de Personas Morales", e);
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

	public AdicionalPersonaMoralBean consultaPrincipal(AdicionalPersonaMoralBean adicionalPersonaMoralBean, int tipoConsulta) {
		AdicionalPersonaMoralBean adicionalPersona = null;

		try {
			String query = "call DIRECTIVOSCON(?,?,?,?,?,?	 ,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(adicionalPersonaMoralBean.getNumCliente()),
					Utileria.convierteEntero(adicionalPersonaMoralBean.getGaranteID()),
					Utileria.convierteEntero(adicionalPersonaMoralBean.getAvalID()),
					Utileria.convierteEntero(adicionalPersonaMoralBean.getDirectivoID()),
					tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA
			, Constantes.STRING_VACIO,
			"AdicionalPersonaMoralDAO.consultaPrincipal",
			Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call DIRECTIVOSCON(" + Arrays.toString(parametros) + ")");
			@SuppressWarnings("unchecked")
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AdicionalPersonaMoralBean adicionalPersonaMoral = new AdicionalPersonaMoralBean();

					adicionalPersonaMoral.setNumeroCte(resultSet.getString("RelacionadoID"));
					adicionalPersonaMoral.setCargoID(resultSet.getString("CargoID"));
					adicionalPersonaMoral.setEsApoderado(resultSet.getString("EsApoderado"));
					adicionalPersonaMoral.setConsejoAdmon(resultSet.getString("ConsejoAdmon"));
					adicionalPersonaMoral.setEsAccionista(resultSet.getString("EsAccionista"));
					adicionalPersonaMoral.setGaranteRelacion(resultSet.getString("GaranteRelacion"));
					adicionalPersonaMoral.setAvalRelacion(resultSet.getString("AvalRelacion"));

					adicionalPersonaMoral.setTitulo(resultSet.getString("Titulo"));
					adicionalPersonaMoral.setPrimerNombre(resultSet.getString("PrimerNombre"));
					adicionalPersonaMoral.setSegundoNombre(resultSet.getString("SegundoNombre"));
					adicionalPersonaMoral.setTercerNombre(resultSet.getString("TercerNombre"));
					adicionalPersonaMoral.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));

					adicionalPersonaMoral.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					adicionalPersonaMoral.setNombreCompleto(resultSet.getString("NombreCompleto"));
					adicionalPersonaMoral.setFechaNacimiento(resultSet.getString("FechaNac"));
					adicionalPersonaMoral.setPaisNacimiento(resultSet.getString("PaisNacimiento"));
					adicionalPersonaMoral.setEdoNacimiento(resultSet.getString("EdoNacimiento"));
					adicionalPersonaMoral.setEstadoCivil(resultSet.getString("EstadoCivil"));

					adicionalPersonaMoral.setSexo(resultSet.getString("Sexo"));
					adicionalPersonaMoral.setNacion(resultSet.getString("Nacionalidad"));
					adicionalPersonaMoral.setCURP(resultSet.getString("CURP"));
					adicionalPersonaMoral.setRFC(resultSet.getString("RFC"));
					adicionalPersonaMoral.setOcupacionID(resultSet.getString("OcupacionID"));

					adicionalPersonaMoral.setFEA(resultSet.getString("FEA"));
					adicionalPersonaMoral.setPaisFea(resultSet.getString("PaisFEA"));
					adicionalPersonaMoral.setPaisRFC(resultSet.getString("PaisRFC"));
					adicionalPersonaMoral.setPuestoA(resultSet.getString("PuestoA"));
					adicionalPersonaMoral.setSectorGeneral(resultSet.getString("SectorGeneral"));
					adicionalPersonaMoral.setActividadBancoMX(resultSet.getString("ActividadBancoMX"));

					adicionalPersonaMoral.setActividadINEGI(resultSet.getString("ActividadINEGI"));
					adicionalPersonaMoral.setSectorEconomico(resultSet.getString("SectorEconomico"));
					adicionalPersonaMoral.setTipoIdentiID(resultSet.getString("TipoIdentiID"));
					adicionalPersonaMoral.setOtraIdentifi(resultSet.getString("OtraIdentifi"));
					adicionalPersonaMoral.setNumIdentific(resultSet.getString("NumIdentific"));

					adicionalPersonaMoral.setFecExIden(resultSet.getString("FecExIden"));
					adicionalPersonaMoral.setFecVenIden(resultSet.getString("FecVenIden"));
					adicionalPersonaMoral.setDomicilio(resultSet.getString("Domicilio"));
					adicionalPersonaMoral.setTelefonoCasa(resultSet.getString("TelefonoCasa"));
					adicionalPersonaMoral.setTelefonoCelular(resultSet.getString("TelefonoCelular"));

					adicionalPersonaMoral.setCorreo(resultSet.getString("Correo"));
					adicionalPersonaMoral.setPaisResidencia(resultSet.getString("PaisResidencia"));
					adicionalPersonaMoral.setDocEstanciaLegal(resultSet.getString("DocEstanciaLegal"));
					adicionalPersonaMoral.setDocExisLegal(resultSet.getString("DocExisLegal"));
					adicionalPersonaMoral.setFechaVenEst(resultSet.getString("FechaVenEst"));

					adicionalPersonaMoral.setNumEscPub(resultSet.getString("NumEscPub"));
					adicionalPersonaMoral.setEstadoID(resultSet.getString("EstadoID"));
					adicionalPersonaMoral.setMunicipioID(resultSet.getString("MunicipioID"));
					adicionalPersonaMoral.setFechaEscPub(resultSet.getString("FechaEscPub"));
					adicionalPersonaMoral.setNotariaID(resultSet.getString("NotariaID"));
					adicionalPersonaMoral.setFax(resultSet.getString("Fax"));
					adicionalPersonaMoral.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
					adicionalPersonaMoral.setIngreRealoRecursos(resultSet.getString("IngresoRealoRecur"));

					adicionalPersonaMoral.setPorcentajeAccion(resultSet.getString("PorcentajeAcciones"));
					adicionalPersonaMoral.setValorAcciones(resultSet.getString("ValorAcciones"));
					adicionalPersonaMoral.setEsPropReal(resultSet.getString("EsPropietarioReal"));
					adicionalPersonaMoral.setFolioMercantil(resultSet.getString("FolioMercantil"));
					adicionalPersonaMoral.setTipoAccionista(resultSet.getString("TipoAccionista"));

					adicionalPersonaMoral.setCompania(resultSet.getString("NombreCompania"));
					adicionalPersonaMoral.setDireccion1(resultSet.getString("Direccion1"));
					adicionalPersonaMoral.setDireccion2(resultSet.getString("Direccion2"));
					adicionalPersonaMoral.setMunNacimiento(resultSet.getString("MunNacimiento"));
					adicionalPersonaMoral.setLocNacimiento(resultSet.getString("LocNacimiento"));

					adicionalPersonaMoral.setColoniaID(resultSet.getString("ColoniaID"));
					adicionalPersonaMoral.setNombreCiudad(resultSet.getString("NombreCiudad"));
					adicionalPersonaMoral.setCodigoPostal(resultSet.getString("CodigoPostal"));
					adicionalPersonaMoral.setEdoExtranjero(resultSet.getString("EdoExtranjero"));
					adicionalPersonaMoral.setEsSolicitante(resultSet.getString("EsSolicitante"));

					adicionalPersonaMoral.setEsAutorizador(resultSet.getString("EsAutorizador"));
					adicionalPersonaMoral.setEsAdministrador(resultSet.getString("EsAdministrador"));
					adicionalPersonaMoral.setPaisIDDom(resultSet.getString("PaisIDDom"));
					adicionalPersonaMoral.setEstadoIDDom(resultSet.getString("EstadoIDDom"));
					adicionalPersonaMoral.setMunicipioIDDom(resultSet.getString("MunicipioIDDom"));

					adicionalPersonaMoral.setLocalidadIDDom(resultSet.getString("LocalidadIDDom"));
					adicionalPersonaMoral.setColoniaIDDom(resultSet.getString("ColoniaIDDom"));
					adicionalPersonaMoral.setNombreColoniaDom(resultSet.getString("NombreColoniaDom"));
					adicionalPersonaMoral.setNombreCiudadDom(resultSet.getString("NombreCiudadDom"));
					adicionalPersonaMoral.setCalleDom(resultSet.getString("CalleDom"));

					adicionalPersonaMoral.setNumExteriorDom(resultSet.getString("NumExteriorDom"));
					adicionalPersonaMoral.setNumInteriorDom(resultSet.getString("NumInteriorDom"));
					adicionalPersonaMoral.setPisoDom(resultSet.getString("PisoDom"));
					adicionalPersonaMoral.setPrimeraEntreDom(resultSet.getString("PrimeraEntreDom"));
					adicionalPersonaMoral.setSegundaEntreDom(resultSet.getString("SegundaEntreDom"));

					adicionalPersonaMoral.setCodigoPostalDom(resultSet.getString("CodigoPostalDom"));

					return adicionalPersonaMoral;
				}
			});
			adicionalPersona = matches.size() > 0 ? (AdicionalPersonaMoralBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en la consulta de Directivos del Cliente");
		}
		return adicionalPersona;
	}

	/* lista para traer los usuarios qu tienen un limite de Operaciones */
	public List listaDirectivos(AdicionalPersonaMoralBean adicionalPersonaMoralBean, int tipoLista) {
		List adicionalPersonaMoralBeanCon = null;
		try {
			// Query con el Store Procedure

			String query = "call DIRECTIVOSLIS(?,?,?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {adicionalPersonaMoralBean.getNumCliente(),adicionalPersonaMoralBean.getGaranteID(),
					adicionalPersonaMoralBean.getAvalID(),
					adicionalPersonaMoralBean.getNombreDirectivo(), tipoLista,

			parametrosAuditoriaBean.getEmpresaID(), parametrosAuditoriaBean.getUsuario(), parametrosAuditoriaBean.getFecha(), parametrosAuditoriaBean.getDireccionIP(), "AdicionalPersonaMoralDAO.listaDirectivos", parametrosAuditoriaBean.getSucursal(), parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call DIRECTIVOSLIS(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AdicionalPersonaMoralBean adicionalPersonaMoral = new AdicionalPersonaMoralBean();
					adicionalPersonaMoral.setDirectivoID(resultSet.getString("DirectivoID"));
					adicionalPersonaMoral.setNombreDirectivo(resultSet.getString("NombreCompleto"));

					return adicionalPersonaMoral;

				}
			});

			adicionalPersonaMoralBeanCon = matches;

		} catch (Exception e) {

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en la Lista de Información Adicional de Personas Morales", e);

		}
		return adicionalPersonaMoralBeanCon;

	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}