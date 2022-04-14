package seguridad.dao;



import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import general.servicio.ParametrosAplicacionServicio;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.bean.BitacoraAccesoBean;
import soporte.bean.UsuarioBean;

public class BitacoraAccesoDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;
 	ParametrosAplicacionServicio parametrosAplicacionServicio = null;

	public BitacoraAccesoDAO(){
		super();
	}

	public MensajeTransaccionBean AltaBitacoraAcceso(final BitacoraAccesoBean bitacoraAccesoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call BITACORAACCESOALT(" +
											"?,?,?,?,?, ?,?,?,?," +
											"?,?," +
											"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(bitacoraAccesoBean.getSucursalID()));
									sentenciaStore.setString("Par_ClaveUsuario",bitacoraAccesoBean.getClaveUsuario());
									sentenciaStore.setInt("Par_Perfil",Utileria.convierteEntero(bitacoraAccesoBean.getPerfil()));
									sentenciaStore.setString("Par_AccesoIP",bitacoraAccesoBean.getAccesoIP());
									sentenciaStore.setString("Par_Recurso",bitacoraAccesoBean.getRecurso());

									sentenciaStore.setInt("Par_TipoAcceso",Utileria.convierteEntero(bitacoraAccesoBean.getTipoAcceso()));
									sentenciaStore.setString("Par_TipoMetodo",bitacoraAccesoBean.getTipoMetodo());
									sentenciaStore.setString("Par_DetalleAcceso",bitacoraAccesoBean.getDetalleAcceso());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BitacoraAccesoDAO.altaBitacoraAcceso");
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
							throw new Exception(Constantes.MSG_ERROR + " .BitacoraAccesoDAO.altaBitacoraAcceso");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de bitacora de acceso" + e);
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


	/* Consulta de Usuario: Para Pantalla de Login */
	public UsuarioBean consultaPorClaveLoginBDPrincipal(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		UsuarioBean usuario = null;
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								usuarioBean.getClave(),
								Constantes.STRING_VACIO,// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaPorClave",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		//loggerSAFI.info("Principal - logTomcat "+"call USUARIOSCONBDPrin(" + Arrays.toString(parametros) +")");


		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setClave(resultSet.getString("Clave"));
					usuario.setNombreRol(resultSet.getString("Descripcion"));
					usuario.setEstatus(resultSet.getString("Estatus"));
					usuario.setLoginsFallidos(resultSet.getInt("LoginsFallidos"));
					usuario.setEstatusSesion(resultSet.getString("EstatusSesion"));
					usuario.setSalt(resultSet.getString("Semilla"));
					usuario.setOrigenDatos(resultSet.getString("OrigenDatos"));
					usuario.setRutaReportes(resultSet.getString("RutaReportes"));
					usuario.setRutaImgReportes(resultSet.getString("RutaImgReportes"));
					usuario.setLogoCtePantalla(resultSet.getString("LogoCtePantalla"));
//					usuario.setRazonSocial(resultSet.getString("RazonSocial"));
					return usuario;
				}
			});

			usuario = matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta por clave en Bitacora Acceso", e);
		}


		return usuario;

	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
}
