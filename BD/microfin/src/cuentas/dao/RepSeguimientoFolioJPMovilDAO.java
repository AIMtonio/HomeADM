package cuentas.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cuentas.bean.RepSeguimientoFolioJPMovilBean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RepSeguimientoFolioJPMovilDAO extends BaseDAO{
	
	public RepSeguimientoFolioJPMovilDAO(){
		super();
	}
	
	/**
	 * Metodo para traer de la BD la lista de objetos para el reporte de Historico de Seguimiento JPMovil
	 * @param repSeguimientoFolioJPMovilBean
	 * @param tipoReporte
	 * @return lista de objetos con el historico del seguimiento de folios jpmovil
	 */
	public List <RepSeguimientoFolioJPMovilBean> repHisSeguimientoJPMovil(final RepSeguimientoFolioJPMovilBean repSeguimientoFolioJPMovilBean, final int  tipoReporte){
		List<RepSeguimientoFolioJPMovilBean> repSeguimientoJPMovil = null;
		
		try {
				String query="call SEGUIMIENTOJPMOVILREP(?,?,?,?,?, ?,	?,?,?,?,?,?,?)";
				Object[] parametros={
		
					repSeguimientoFolioJPMovilBean.getFechaInicio(),
					repSeguimientoFolioJPMovilBean.getFechaFin(),
					Utileria.convierteEntero(repSeguimientoFolioJPMovilBean.getClienteID()),
					repSeguimientoFolioJPMovilBean.getEstatus(),
					repSeguimientoFolioJPMovilBean.getIncluyeComentario(),
					tipoReporte,
						
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMIENTOJPMOVILREP("+ Arrays.toString(parametros)+")");
				@SuppressWarnings("unchecked")
				List<RepSeguimientoFolioJPMovilBean> matches=((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
						RepSeguimientoFolioJPMovilBean seguimientoBean = new RepSeguimientoFolioJPMovilBean();
						
						seguimientoBean.setClienteID(resultSet.getString("ClienteID"));
						seguimientoBean.setNombreCompleto(resultSet.getString("NombreCliente"));
						seguimientoBean.setTeléfonoCelular(resultSet.getString("Telefono"));
						seguimientoBean.setNumeroCuenta(resultSet.getString("CuentaAhoID"));
						seguimientoBean.setSeguimientoID(resultSet.getString("SeguimientoID"));
						seguimientoBean.setSucursal(resultSet.getString("SucursalOrigen"));
						seguimientoBean.setEstatus(resultSet.getString("Estatus"));
						seguimientoBean.setFechaApertura(resultSet.getString("FechaRegistro"));
						seguimientoBean.setHora(resultSet.getString("HoraRegistro"));
						seguimientoBean.setTipoSoporte(resultSet.getString("TipoSoporte"));
						seguimientoBean.setUsuario(resultSet.getString("UsuarioNombre"));
						seguimientoBean.setUltimoComentario(resultSet.getString("UltimoComentario"));
						seguimientoBean.setRespuestaCliente(resultSet.getString("ComentarioCliente"));
						seguimientoBean.setComentarioUsuario(resultSet.getString("ComentarioUsuario"));
						return seguimientoBean;
					}
				});
				repSeguimientoJPMovil = matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en generar el reporte seguimiento de folios jpmovil ", e);
			}
			return repSeguimientoJPMovil;
		}
}
