package regulatorios.dao;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioA1316Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioA1316DAO  extends BaseDAO  {

	public RegulatorioA1316DAO() {
        super();
    }
    
    /* CSV */    
    public List <RegulatorioA1316Bean> reporteRegulatorioA1316Csv(final RegulatorioA1316Bean bean, int tipoReporte){ 
        transaccionDAO.generaNumeroTransaccion();
        String query = "call REGA131600003REP(?,?,?,?,?, ?,?,?,?,?)";

        Object[] parametros ={
				    		bean.getFechaConsultaActual(),
				            bean.getFechaConsultaAnterior(),
				            tipoReporte,
				            parametrosAuditoriaBean.getEmpresaID(),
				            parametrosAuditoriaBean.getUsuario(),
				            parametrosAuditoriaBean.getFecha(),
				            parametrosAuditoriaBean.getDireccionIP(),
				            "regulatorioA1316DAO.reporteRegulatorioA1316Csv",
				            parametrosAuditoriaBean.getSucursal(),
				            parametrosAuditoriaBean.getNumeroTransaccion()
        };
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA131600003REP(" + Arrays.toString(parametros) +")");
        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
            public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                
                RegulatorioA1316Bean beanResponse= new RegulatorioA1316Bean();
                beanResponse.setValor(resultSet.getString("Valor"));

                return beanResponse ;
            }
        });
		return matches;
    }
    
    /* EXCEL */
    public List <RegulatorioA1316Bean> reporteRegulatorioA1316Excel(final RegulatorioA1316Bean bean, int tipoReporte){ 
        transaccionDAO.generaNumeroTransaccion();
        String query = "call REGA131600003REP(?,?,?,?,?, ?,?,?,?,?)";

        Object[] parametros ={
                            bean.getFechaConsultaActual(),
                            bean.getFechaConsultaAnterior(),
                            tipoReporte,
                            parametrosAuditoriaBean.getEmpresaID(),
                            parametrosAuditoriaBean.getUsuario(),
                            parametrosAuditoriaBean.getFecha(),
                            parametrosAuditoriaBean.getDireccionIP(),
                            "regulatorioA1316DAO.reporteRegulatorioA1316Excel",
                            parametrosAuditoriaBean.getSucursal(),
                            parametrosAuditoriaBean.getNumeroTransaccion()
        };
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA131600003REP(" + Arrays.toString(parametros) +")");
        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {         
       
        	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				int count = resultSet.getMetaData().getColumnCount();
				RegulatorioA1316Bean beanResponse = new RegulatorioA1316Bean();
        		beanResponse.setCuentaContable(resultSet.getString("CuentaContable"));
        		beanResponse.setDescripcionCuenta(resultSet.getString("DescripcionCuenta"));				
        		beanResponse.setCargos(resultSet.getString("Cargos"));
        		beanResponse.setNegrita(resultSet.getString("Negrita"));
				
				return beanResponse;	
        	}
		});
        return matches;
	}
        
}

