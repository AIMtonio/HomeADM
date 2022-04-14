package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.TasasInversionBean;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.sql.DataSource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.EstadosRepubBean;
import cliente.bean.TiposDireccionBean;

public class TiposDireccionDAO  extends BaseDAO{

	
	public TiposDireccionDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------
	
	//consulta de Tipos de  direcciones
		public TiposDireccionBean consultaPrincipal(int tipoDireccionID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPOSDIRECCIONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoDireccionID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposDireccionDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSDIRECCIONCON(" + Arrays.toString(parametros) + ")");
		
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposDireccionBean direcciones = new TiposDireccionBean();
					
				direcciones.setTipoDireccionID(Utileria.completaCerosIzquierda(resultSet.getInt(1),5));
				direcciones.setEmpresaID(Utileria.completaCerosIzquierda(resultSet.getInt(2),10));
				direcciones.setDescripcion(resultSet.getString(3));					
				direcciones.setOficial(resultSet.getString(4));	
					return direcciones;
	
			}
		});
		return matches.size() > 0 ? (TiposDireccionBean) matches.get(0) : null;
				
	}
		
		// consulta foranea
		public TiposDireccionBean consultaForanea(int tipoDireccionID, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call TIPOSDIRECCIONCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	tipoDireccionID,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"TiposDireccionDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSDIRECCIONCON(" + Arrays.toString(parametros) + ")");
			
			
					
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposDireccionBean direcciones = new TiposDireccionBean();
						
					direcciones.setTipoDireccionID(Utileria.completaCerosIzquierda(resultSet.getInt(1),5));
					direcciones.setDescripcion(resultSet.getString(2));					
					
						return direcciones;
		
				}
			});
			return matches.size() > 0 ? (TiposDireccionBean) matches.get(0) : null;
					
		}
	
	

		
	
	//Lista de Tipos de direccion
	public List listaTiposDirec(TiposDireccionBean direcciones, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSDIRECCIONLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	direcciones.getDescripcion(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposDireccionDAO.listaTiposDirec",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSDIRECCIONLIS(" + Arrays.toString(parametros) + ")");
		
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposDireccionBean direcciones = new TiposDireccionBean();
				direcciones.setTipoDireccionID(String.valueOf(resultSet.getInt(1)));
				direcciones.setDescripcion(resultSet.getString(2));					
				return direcciones;				
			}
		});
				
		return matches;
	}
	
	// listaTipos de Direccion bombobox
	public List listaTiposDireccionC(int tipoLista){
		String query = "call TIPOSDIRECCIONLIS(?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposDireccionDAO.listaTiposDireccionC",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSDIRECCIONLIS(" + Arrays.toString(parametros) + ")");
			
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				TiposDireccionBean direcciones = new TiposDireccionBean();
				direcciones.setTipoDireccionID(String.valueOf(resultSet.getInt(1)));
				direcciones.setDescripcion(resultSet.getString(2));					
				return direcciones;				
			}
		});
		return matches;
				
	}
	

}
