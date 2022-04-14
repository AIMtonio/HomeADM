package originacion.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
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

import javax.sql.DataSource;

import originacion.bean.ReferenciaClienteBean;
import tesoreria.bean.DistCCInvBancariaBean;

public class ReferenciaClienteDAO extends BaseDAO{

	public ReferenciaClienteDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final ReferenciaClienteBean referenciaCliente) {
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

								referenciaCliente.setTelefono(referenciaCliente.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

								String query = "CALL REFERENCIACLIENTEALT("
										+"?,?,?,?,?,	"
										+"?,?,?,?,?,	"
										+"?,?,?,?,?,	"
										+"?,?,?,?,?,	"
										+"?,?,?,?,?,	"
										+"?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(referenciaCliente.getSolicitudCreditoID()));
								sentenciaStore.setString("Par_PrimerNombre",referenciaCliente.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNombre",referenciaCliente.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNombre",referenciaCliente.getTercerNombre());
								sentenciaStore.setString("Par_ApellidoPaterno",referenciaCliente.getApellidoPaterno());

								sentenciaStore.setString("Par_ApellidoMaterno",referenciaCliente.getApellidoMaterno());
								sentenciaStore.setString("Par_Telefono",referenciaCliente.getTelefono());
								sentenciaStore.setString("Par_ExtTelefonoPart",referenciaCliente.getExtTelefonoPart());
								sentenciaStore.setString("Par_Validado",referenciaCliente.getValidado());
								sentenciaStore.setString("Par_Interesado",referenciaCliente.getInteresado());

								sentenciaStore.setInt("Par_TipoRelacionID",Utileria.convierteEntero(referenciaCliente.getTipoRelacionID()));
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(referenciaCliente.getEstadoID()));
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(referenciaCliente.getMunicipioID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(referenciaCliente.getLocalidadID()));
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(referenciaCliente.getColoniaID()));

								sentenciaStore.setString("Par_Calle",referenciaCliente.getCalle());
								sentenciaStore.setString("Par_NumeroCasa",referenciaCliente.getNumeroCasa());
								sentenciaStore.setString("Par_NumInterior",referenciaCliente.getNumInterior());
								sentenciaStore.setString("Par_Piso",referenciaCliente.getPiso());
								sentenciaStore.setString("Par_CP",referenciaCliente.getCp());


								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());

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
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
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
							if(mensajeBean.getNumero()==45){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del referenciaCliente de servicios: " + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del referenciaCliente de servicios: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Método para dar de baja todas las referencias de la solicitud de crédito.
	 * @param referenciaCliente
	 * @return
	 */
	public MensajeTransaccionBean baja(final ReferenciaClienteBean referenciaCliente) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL REFERENCIACLIENTEBAJ("
										+"?,?,?,?,?,	"
										+"?,?,?,?,?,    " +
										"?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(referenciaCliente.getSolicitudCreditoID()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setNombreControl("graba");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja del referencias Cliente: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<ReferenciaClienteBean> listaReferenciaCliente(ReferenciaClienteBean referenciaCliente, int tipoLista) {
		String query = "CALL REFERENCIACLIENTELIS(" +
				"?,?,?,?,?,   " +
				"?,?,?,?,?);";
		Object[] parametros = {
				referenciaCliente.getSolicitudCreditoID(),
				referenciaCliente.getClienteID(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"ReferenciaClienteDAO.listaReferenciaCliente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REFERENCIACLIENTELIS(" + Arrays.toString(parametros) + ")");

		List<ReferenciaClienteBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReferenciaClienteBean referenciaClienteBean = new ReferenciaClienteBean();
				referenciaClienteBean.setReferenciaID(resultSet.getString("ReferenciaID"));
				referenciaClienteBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				referenciaClienteBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
				referenciaClienteBean.setSegundoNombre(resultSet.getString("SegundoNombre"));
				referenciaClienteBean.setTercerNombre(resultSet.getString("TercerNombre"));
				referenciaClienteBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				referenciaClienteBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				referenciaClienteBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				referenciaClienteBean.setTelefono(resultSet.getString("Telefono"));
				referenciaClienteBean.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
				referenciaClienteBean.setValidado(resultSet.getString("Validado"));
				referenciaClienteBean.setInteresado(resultSet.getString("Interesado"));
				referenciaClienteBean.setTipoRelacionID(resultSet.getString("TipoRelacionID"));
				referenciaClienteBean.setEstadoID(resultSet.getString("EstadoID"));
				referenciaClienteBean.setMunicipioID(resultSet.getString("MunicipioID"));
				referenciaClienteBean.setLocalidadID(resultSet.getString("LocalidadID"));
				referenciaClienteBean.setColoniaID(resultSet.getString("ColoniaID"));
				referenciaClienteBean.setCalle(resultSet.getString("Calle"));
				referenciaClienteBean.setNumeroCasa(resultSet.getString("NumeroCasa"));
				referenciaClienteBean.setNumInterior(resultSet.getString("NumInterior"));
				referenciaClienteBean.setPiso(resultSet.getString("Piso"));
				referenciaClienteBean.setCp(resultSet.getString("CP"));
				referenciaClienteBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				referenciaClienteBean.setNombreCte(resultSet.getString("Solicitante"));
				referenciaClienteBean.setDescripcionRelacion(resultSet.getString("descripcionRelacion"));
				referenciaClienteBean.setNombreEstado(resultSet.getString("NombreEstado"));
				referenciaClienteBean.setNombreMuni(resultSet.getString("NombreMuni"));
				referenciaClienteBean.setNombreLocalidad(resultSet.getString("NombreLocalidad"));
				referenciaClienteBean.setNombreColonia(resultSet.getString("NombreColonia"));

				return referenciaClienteBean;
			}
		});
		return matches;
	}
	public List<ReferenciaClienteBean> listaPLDCliente(ReferenciaClienteBean referenciaCliente, int tipoLista) {
		String query = "CALL REFERENCIACLIENTELIS(" +
				"?,?,?,?,?,   " +
				"?,?,?,?,?);";
		Object[] parametros = {
				referenciaCliente.getSolicitudCreditoID(),
				referenciaCliente.getClienteID(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"ReferenciaClienteDAO.listaReferenciaCliente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REFERENCIACLIENTELIS(" + Arrays.toString(parametros) + ")");

		List<ReferenciaClienteBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReferenciaClienteBean referenciaClienteBean = new ReferenciaClienteBean();
				referenciaClienteBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				referenciaClienteBean.setTelefono(resultSet.getString("Telefono"));
				referenciaClienteBean.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));

				return referenciaClienteBean;
			}
		});
		return matches;
	}

	/* metodo de lista para obtener los datos para el reporte */
	public List<ReferenciaClienteBean> listaReporte(final ReferenciaClienteBean referenciaClienteBean){
		List<ReferenciaClienteBean> ListaResultado=null;
		int tipoReporte = 1;
		try{
		String query = "CALL REFERENCIACLIENTEREP(?,?,?,?,?," +
												" ?,?,?,?,?," +
												" ?,?)";
		Object[] parametros ={
				Utileria.convierteEntero(referenciaClienteBean.getProductoCreditoID()),
				Utileria.convierteFecha(referenciaClienteBean.getFechaInicio()),
				Utileria.convierteFecha(referenciaClienteBean.getFechaFin()),
				referenciaClienteBean.getInteresado(),
				tipoReporte,

	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL REFERENCIACLIENTEREP(  " + Arrays.toString(parametros) + ");");
		List<ReferenciaClienteBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReferenciaClienteBean referenciasBean= new ReferenciaClienteBean();

				referenciasBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				referenciasBean.setNombreCte(resultSet.getString("Solicitante"));
				referenciasBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				referenciasBean.setTelefono(resultSet.getString("Telefono"));
				referenciasBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));

				return referenciasBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte de referencias por solicitud de credito: ", e);
		}
		return ListaResultado;
	}// fin lista report

	public MensajeTransaccionBean altaDetalles(final ReferenciaClienteBean referenciaClienteBean, final ArrayList<ReferenciaClienteBean> listaDetalle) {
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean=baja(referenciaClienteBean);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					for (int i = 0; i < listaDetalle.size(); i++) {
						ReferenciaClienteBean referencia = listaDetalle.get(i);
						referencia.setSolicitudCreditoID(referenciaClienteBean.getSolicitudCreditoID());
						mensajeBean = alta(referencia);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("agrega");
					mensajeBean.setConsecutivoString("0");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Referencias:", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

}

