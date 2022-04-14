package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import regulatorios.bean.RegulatorioA1311Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioA1311DAO  extends BaseDAO  {
	
	public RegulatorioA1311DAO() {
        super();
    }
	
	/* CSV */    
    public List <RegulatorioA1311Bean> reporteRegulatorioA1311Csv(final RegulatorioA1311Bean bean, int tipoReporte){ 
        transaccionDAO.generaNumeroTransaccion();
        String query = "call REGA131100003REP(?,?,?,?,?, ?,?,?,?,?)";

        Object[] parametros ={
				    		bean.getFechaConsultaActual(),
				            bean.getFechaConsultaAnterior(),
				            tipoReporte,
				            parametrosAuditoriaBean.getEmpresaID(),
				            parametrosAuditoriaBean.getUsuario(),
				            parametrosAuditoriaBean.getFecha(),
				            parametrosAuditoriaBean.getDireccionIP(),
				            "regulatorioA1311DAO.reporteRegulatorioA1311Csv",
				            parametrosAuditoriaBean.getSucursal(),
				            parametrosAuditoriaBean.getNumeroTransaccion()
        };
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA131100003REP(" + Arrays.toString(parametros) +")");
        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
            public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                
            	RegulatorioA1311Bean beanResponse= new RegulatorioA1311Bean();
                beanResponse.setValor(resultSet.getString("Valor"));

                return beanResponse ;
            }
        });
		return matches;
    }
    /* EXCEL */
    public List <RegulatorioA1311Bean> reporteRegulatorioA1311Excel(final RegulatorioA1311Bean bean, int tipoReporte){ 
        transaccionDAO.generaNumeroTransaccion();
        String query = "call REGA131100003REP(?,?,?,?,?, ?,?,?,?,?)";

        Object[] parametros ={
                            bean.getFechaConsultaActual(),
                            bean.getFechaConsultaAnterior(),
                            tipoReporte,
                            parametrosAuditoriaBean.getEmpresaID(),
                            parametrosAuditoriaBean.getUsuario(),
                            parametrosAuditoriaBean.getFecha(),
                            parametrosAuditoriaBean.getDireccionIP(),
                            "regulatorioA1311DAO.reporteRegulatorioA1311Excel",
                            parametrosAuditoriaBean.getSucursal(),
                            parametrosAuditoriaBean.getNumeroTransaccion()
        };
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA131100003REP(" + Arrays.toString(parametros) +")");
        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {         
       
        	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				int count = resultSet.getMetaData().getColumnCount();
				RegulatorioA1311Bean beanResponse = new RegulatorioA1311Bean();
				
				beanResponse.setCaTConceptos(resultSet.getString("CaTConceptos"));
				beanResponse.setDescripcion(resultSet.getString("Descripcion"));
				beanResponse.setParticipacionControladora(resultSet.getString("ParticipacionControladora"));
				beanResponse.setCapitalSocial(resultSet.getString("CapitalSocial"));
				beanResponse.setAportacionesCapital(resultSet.getString("AportacionesCapital"));
				beanResponse.setPrimaVenta(resultSet.getString("PrimaVenta"));
				beanResponse.setObligacionesSubordinadas(resultSet.getString("ObligacionesSubordinadas"));
				beanResponse.setIncorporacionSocFinancieras(resultSet.getString("IncorporacionSocFinancieras"));
				beanResponse.setReservaCapital(resultSet.getString("ReservaCapital"));
				beanResponse.setResultadoEjerAnterior(resultSet.getString("ResultadoEjerAnterior"));
				beanResponse.setResultadoTitulosVenta(resultSet.getString("ResultadoTitulosVenta"));
				beanResponse.setResultadoValuacionInstrumentos(resultSet.getString("ResultadoValuacionInstrumentos"));
				beanResponse.setEfectoAcomulado(resultSet.getString("EfectoAcomulado"));
				beanResponse.setBeneficioEmpleados(resultSet.getString("BeneficioEmpleados"));
				beanResponse.setResultadoMonetario(resultSet.getString("ResultadoMonetario"));
				beanResponse.setResultadoActivos(resultSet.getString("ResultadoActivos"));
				beanResponse.setParticipacionNoControladora(resultSet.getString("ParticipacionNoControladora"));
				beanResponse.setCapitalContable(resultSet.getString("CapitalContable"));
        		beanResponse.setNegrita(resultSet.getString("Negrita"));
				
				return beanResponse;	
        	}
		});
      return matches;
        
	}
}
