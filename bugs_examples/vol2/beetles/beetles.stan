data {
    int(0,) N;
    int(0,) n[N];
    int(0,) r[N];
    double x[N];
}
derived data {
    double mean_x;
    double centered_x[N];

    mean_x <- mean(x);
    for (i in 1:N)
        centered_x[i] <- x[i] - mean_x;
}
parameters {
    double alpha_star;
    double beta;
    double rhat[N];
}
derived parameters {
    double alpha;
    double llike[N];
    double p[N];

    alpha <- alpha_star - beta*mean_x;
}


model {
   alpha_star ~ normal(0.0, 1.0E2);	
   beta ~ normal(0.0, 1.0E2);
   for (i in 1:N) {
      r[i] ~ binomial(n[i], p[i]);
      p[i] <- inv_logit(alpha_star + beta*centered_x[i]); 
      // log likelihood for sample i & saturated log-likelihood:
      llike[i]  <- r[i]*log(p[i]) + (n[i]-r[i])*log(1-p[i]);  
      // llike.sat[i] <- r[i]*log(r[i]/n[i]) + (n[i]-r[i])*log(1-r[i]/n[i]);
      rhat[i] <- p[i]*n[i];  // fitted values
    }
    //D <- 2 * (sum(llike.sat[]) - sum(llike[]));
}