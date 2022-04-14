package cliente.dao;
 
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.LocalidadRepubBean;
import cliente.bean.ReporteLocalidadesMarginadasBean;


public class LocalidadRepubDAO extends BaseDAO{
	
	
	public LocalidadRepubDAO() {
		super();
	}
	public List listaLocalidad(LocalidadRepubBean localidad, int tipoLista) {
		//Query con el Store Procedure
		String query = "call LOCALIDADREPUBLIS(?,?,?,?,?, ?,?,?,?,? ,?);";
		Object[] parametros = {	localidad.getEstadoID(),
								localidad.getMunicipioID(),
								localidad.getNombreLocalidad(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"LocalidadRepubDAO.listaLocalidad",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LOCALIDADREPUBLIS(" + Arrays.toString(parametros) + ")");
		
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LocalidadRepubBean localidades = new LocalidadRepubBean();		
				localidades.setLocalidadID(Utileria.completaCerosIzquierda(resultSet.getInt("LocalidadID"), 5));
				localidades.setNombreLocalidad(resultSet.getString("NombreLocalidad"));					
				return localidades;				
			}
		});
				
		return matches;
	}
	public List listaLocalidadCNBV(LocalidadRepubBean localidad, int tipoLista) {
		//Query con el Store Procedure
		String query = "call LOCALIDADREPUBLIS(?,?,?,?,?, ?,?,?,?,? ,?);";
		Object[] parametros = {	localidad.getEstadoID(),
								localidad.getMunicipioID(),
								localidad.getNombreLocalidad(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"LocalidadRepubDAO.listaLocalidadCNBV",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LOCALIDADREPUBLIS(" + Arrays.toString(parametros) + ")");
		
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LocalidadRepubBean localidades = new LocalidadRepubBean();		
				localidades.setLocalidadCNBV(resultSet.getString("LocalidadCNBV"));
				localidades.setNombreLocalidad(resultSet.getString("NombreLocalidad"));					
				return localidades;				
			}
		});
				
		return matches;
	}
	public LocalidadRepubBean consultaPrincipal(int estadoID, int municipioID, int localidadID, int principal) {
		//Query con el Store Procedure
		String query = "call  LOCALIDADREPUBCON(?,  ?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = {	estadoID,
								municipioID,
								localidadID,
								principal,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"LocalidadRepubDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LOCALIDADREPUBCON(" + Arrays.toString(parametros) + ")");
		
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LocalidadRepubBean municipios = new LocalidadRepubBean();			
					
				municipios.setLocalidadID(String.valueOf(resultSet.getInt("LocalidadID")));
				municipios.setNombreLocalidad(resultSet.getString("NombreLocalidad"));				
				municipios.setNumHabitantes(resultSet.getString("NumHabitantes"));
				municipios.setEsMarginada(resultSet.getString("EsMarginada"));
					return municipios;
	
			}
		});
		return matches.size() > 0 ? (LocalidadRepubBean) matches.get(0) : null;
		
	}
	public LocalidadRepubBean consultaLocalidadCNBV(int estadoID, int municipioID, String localidadID, int principal) {
		//Query con el Store Procedure
		String query = "call  LOCALIDADREPUBCON(?,  ?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = {	estadoID,
								municipioID,
								Utileria.convierteLong(localidadID),
								principal,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"LocalidadRepubDAO.consultaLocalidadCNBV",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LOCALIDADREPUBCON(" + Arrays.toString(parametros) + ")");
		
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LocalidadRepubBean municipios = new LocalidadRepubBean();			
					
				municipios.setLocalidadCNBV(resultSet.getString("LocalidadCNBV"));
				municipios.setNombreLocalidad(resultSet.getString("NombreLocalidad"));				
				municipios.setNumHabitantes(resultSet.getString("NumHabitantes"));
				municipios.setEsMarginada(resultSet.getString("EsMarginada"));
					return municipios;
	
			}
		});
		return matches.size() > 0 ? (LocalidadRepubBean) matches.get(0) : null;
		
	}
	//---------------------------REPORTES -------------------------------------------------- //
	
	// Reporte Localidades Marginadas //
		public List listaLocalidadesMarginadas( ReporteLocalidadesMarginadasBean reporteLocalidadesMarginadasBean,
												int tipoLista){	
			List ListaResultado=null;
			
			try{
			String query = "call LOCALIDMARGINADASREP(?,?,?,?,?,  ?,?,?,?,?, ?)";

			Object[] parametros ={
								Utileria.convierteFecha(reporteLocalidadesMarginadasBean.getEstadoMarginadasID()),
								Utileria.convierteFecha(reporteLocalidadesMarginadasBean.getMunicipioMarginadasID()),
								Utileria.convierteEntero(reporteLocalidadesMarginadasBean.getLocalidadMarginadasID()),
								tipoLista,
							
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LOCALIDMARGINADASREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteLocalidadesMarginadasBean localidadesMarginadas= new ReporteLocalidadesMarginadasBean();
					localidadesMarginadas.setNombreEstadoMarginadas(resultSet.getString("NombreEstado"));
					localidadesMarginadas.setNombreMunicipioMarginadas(resultSet.getString("NombreMunicipio"));
					localidadesMarginadas.setLocalidadMarginadasID(resultSet.getString("LocalidadID"));
					localidadesMarginadas.setNombreLocalidadMarginadas(resultSet.getString("NombreLocalidad"));				
					localidadesMarginadas.setNumHabitantes(resultSet.getString("NumHabitantes"));
					localidadesMarginadas.setHoraEmision(resultSet.getString("HoraEmision"));
					
					return localidadesMarginadas ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Localidades Marginadas", e);
			}
			return ListaResultado;
		}
	

}
