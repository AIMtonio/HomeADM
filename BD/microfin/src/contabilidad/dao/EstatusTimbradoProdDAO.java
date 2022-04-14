package contabilidad.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import contabilidad.bean.EstatusTimbradoProdBean;


import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class EstatusTimbradoProdDAO extends BaseDAO{

	public EstatusTimbradoProdDAO() {
		super();
	}

	// LISTA DE ESTATUS DE TIMBRADO POR PRODUCTO
	public List listaEstatusTimbrado( EstatusTimbradoProdBean estatusTimbradoProdBean, int tipoLista){
		List listaGrid = null;
	try{String query = "call EDOCTAESTATUSTIMPRODLIS(?,?,		?,?,?,?,?,?,?);";
		Object[] parametros = {	
					estatusTimbradoProdBean.getAnio(), 
					tipoLista,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EstatusTimbradoProdDAO.listaEstatusTimbrado",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO							
					};
		
	
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAESTATUSTIMPRODLIS(" + Arrays.toString(parametros) + ")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EstatusTimbradoProdBean estatusTimbradoProd = new EstatusTimbradoProdBean();
				estatusTimbradoProd.setEnero(resultSet.getString("Mes1"));
				estatusTimbradoProd.setFebrero(resultSet.getString("Mes1"));
				estatusTimbradoProd.setMarzo(resultSet.getString("Mes3"));
				estatusTimbradoProd.setAbril(resultSet.getString("Mes4"));
				estatusTimbradoProd.setMayo(resultSet.getString("Mes5"));
				estatusTimbradoProd.setJunio(resultSet.getString("Mes6"));
				estatusTimbradoProd.setJulio(resultSet.getString("Mes7"));
				estatusTimbradoProd.setAgosto(resultSet.getString("Mes8"));
				estatusTimbradoProd.setSeptiembre(resultSet.getString("Mes9"));
				estatusTimbradoProd.setOctubre(resultSet.getString("Mes10"));
				estatusTimbradoProd.setNoviembre(resultSet.getString("Mes11"));
				estatusTimbradoProd.setDiciembre(resultSet.getString("Mes12"));
				estatusTimbradoProd.setNombreProducto(resultSet.getString("Nombre"));
				estatusTimbradoProd.setProductoID(resultSet.getString("Anio"));
			
											    
				return estatusTimbradoProd;
			}
		});
		listaGrid= matches;			
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Frecuencias por Productos", e);
			
		}		
		return listaGrid;				
	}
	
	// LISTA PARA EL REPORTE DE ESTATUS  DE TIMBRADO POR PRODUCTO
	public List listaEstatusTimbradoRep( EstatusTimbradoProdBean estatusTimbradoProdBean, int tipoLista){
		List listaGrid = null;
	try{String query = "call EDOCTAESTATUSTIMPRODREP(?,?,		?,?,?,?,?,?,?);";
		Object[] parametros = {	
					estatusTimbradoProdBean.getAnio(), 
					tipoLista,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EstatusTimbradoProdDAO.listaEstatusTimbrado",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO							
					};
		
	
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAESTATUSTIMPRODREP(" + Arrays.toString(parametros) + ")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EstatusTimbradoProdBean estatusTimbradoProd = new EstatusTimbradoProdBean();
				estatusTimbradoProd.setEnero(resultSet.getString("Mes1"));
				estatusTimbradoProd.setFebrero(resultSet.getString("Mes1"));
				estatusTimbradoProd.setMarzo(resultSet.getString("Mes3"));
				estatusTimbradoProd.setAbril(resultSet.getString("Mes4"));
				estatusTimbradoProd.setMayo(resultSet.getString("Mes5"));
				estatusTimbradoProd.setJunio(resultSet.getString("Mes6"));
				estatusTimbradoProd.setJulio(resultSet.getString("Mes7"));
				estatusTimbradoProd.setAgosto(resultSet.getString("Mes8"));
				estatusTimbradoProd.setSeptiembre(resultSet.getString("Mes9"));
				estatusTimbradoProd.setOctubre(resultSet.getString("Mes10"));
				estatusTimbradoProd.setNoviembre(resultSet.getString("Mes11"));
				estatusTimbradoProd.setDiciembre(resultSet.getString("Mes12"));
				estatusTimbradoProd.setNombreProducto(resultSet.getString("Nombre"));
				estatusTimbradoProd.setProductoID(resultSet.getString("Anio"));
			
											    
				return estatusTimbradoProd;
			}
		});
		listaGrid= matches;			
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Frecuencias por Productos", e);
			
		}		
		return listaGrid;				
	}
	

}
