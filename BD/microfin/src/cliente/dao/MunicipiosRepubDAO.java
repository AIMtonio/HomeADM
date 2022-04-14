package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.sql.DataSource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.ClienteBean;
import cliente.bean.MunicipiosRepubBean;



public class MunicipiosRepubDAO extends BaseDAO{
	
		
		public MunicipiosRepubDAO() {
			super();
		}
		
		// ------------------ Transacciones ------------------------------------------
		
		//consulta Principal de Municipios
			public MunicipiosRepubBean consultaPrincipal(int estadoID, int municipioID, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call MUNICIPIOSREPUBCON(?,?,?,?,?,?,?,?,?,?);";								 
			Object[] parametros = {	estadoID,
									municipioID,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"MunicipiosRepubDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MUNICIPIOSREPUBCON(" + Arrays.toString(parametros) + ")");
			
					
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MunicipiosRepubBean municipios = new MunicipiosRepubBean();
						
					municipios.setEstadoID(Utileria.completaCerosIzquierda(resultSet.getInt("EstadoID"), 5));
					municipios.setMunicipioID(Utileria.completaCerosIzquierda(resultSet.getInt("MunicipioID"), 5));
					municipios.setEmpresaID(Utileria.completaCerosIzquierda(resultSet.getInt("EmpresaID"),10));
					municipios.setNombre(resultSet.getString("Nombre"));					

						return municipios;
		
				}
			});
			return matches.size() > 0 ? (MunicipiosRepubBean) matches.get(0) : null;
					
		}
		
			//consulta Foranea de Municipios

			public MunicipiosRepubBean consultaForanea(int estadoID, int municipioID, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call  MUNICIPIOSREPUBCON(?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	estadoID,
										municipioID,
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"MunicipiosRepubDAO.consultaForanea",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MUNICIPIOSREPUBCON(" + Arrays.toString(parametros) + ")");
				
						
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						MunicipiosRepubBean municipios = new MunicipiosRepubBean();			
							
						municipios.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
						municipios.setNombre(resultSet.getString("Nombre"));				
						municipios.setCiudad(resultSet.getString("Ciudad"));
							return municipios;
			
					}
				});
				return matches.size() > 0 ? (MunicipiosRepubBean) matches.get(0) : null;
						
			}
			
			public MunicipiosRepubBean consultaLinFondeo(int estadoID, int municipioID, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call  MUNICIPIOSREPUBCON(?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	estadoID,
										municipioID,
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"MunicipiosRepubDAO.consultaLinFondeo",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MUNICIPIOSREPUBCON(" + Arrays.toString(parametros) + ")");
				
						
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						MunicipiosRepubBean municipios = new MunicipiosRepubBean();			
							
						municipios.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
						municipios.setNombre(resultSet.getString("Nombre"));				
						
							return municipios;
			
					}
				});
				return matches.size() > 0 ? (MunicipiosRepubBean) matches.get(0) : null;
						
			}
		//Lista de Municipios
		public List listaMunicipios(MunicipiosRepubBean municipios, int tipoLista) {
			//Query con el Store Procedure
			String query = "call MUNICIPIOSREPUBLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	municipios.getEstadoID(),
									municipios.getNombre(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"MunicipiosRepubDAO.listaMunicipios",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MUNICIPIOSREPUBLIS(" + Arrays.toString(parametros) + ")");
			
			
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MunicipiosRepubBean municipios = new MunicipiosRepubBean();		
					municipios.setMunicipioID(Utileria.completaCerosIzquierda(resultSet.getInt("MunicipioID"), 5));
					municipios.setNombre(resultSet.getString("Nombre"));					
					return municipios;				
				}
			});
					
			return matches;
		}
		
		//Lista de Municipios
		public List listaCiudades(MunicipiosRepubBean municipios, int tipoLista) {
			//Query con el Store Procedure
			String query = "call MUNICIPIOSREPUBLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	municipios.getEstadoID(),
					municipios.getNombre(),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"MunicipiosRepubDAO.listaCiudades",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MUNICIPIOSREPUBLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MunicipiosRepubBean municipios = new MunicipiosRepubBean();		
					municipios.setMunicipioID(Utileria.completaCerosIzquierda(resultSet.getInt("MunicipioID"), 5));
					municipios.setNombre(resultSet.getString("Nombre"));
					municipios.setCiudad(resultSet.getString("Ciudad"));
					return municipios;
				}
			});

			return matches;
		}
}
